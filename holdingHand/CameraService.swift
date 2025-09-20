import Foundation
import AVFoundation
import Combine
import Photos

class CameraService: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    var session: AVCaptureSession?
    @Published var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    var onPhotoCaptured: ((Data) -> Void)?

    func setup() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Error: Could not create AVCaptureDeviceInput")
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            print("Error: Could not add input to session")
        }

        photoOutput = AVCapturePhotoOutput()
        if let photoOutput = photoOutput, session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            print("Error: Could not add output to session")
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill

        self.session = session
    }

    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Starting camera session")
            self.session?.startRunning()
        }
    }

    func stop() {
        print("Stopping camera session")
        session?.stopRunning()
    }

    func capturePhoto() {
        print("Capturing photo")
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        guard let data = photo.fileDataRepresentation() else { return }
        onPhotoCaptured?(data)
    }

    func savePhoto(imageData: Data) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }

            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
            }, completionHandler: { _, error in
                if let error = error {
                    print("Error saving photo: \(error.localizedDescription)")
                }
            })
        }
    }
}