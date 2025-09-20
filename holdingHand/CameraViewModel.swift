import Foundation
import AVFoundation
import Combine
import UIKit

class CameraViewModel: ObservableObject {
    private let cameraService = CameraService()
    
    @Published var capturedImage: UIImage?
    @Published var isPreviewing = false
    @Published var overlayText: String = ""
    @Published var isEditingText: Bool = false
    
    var previewLayer: AVCaptureVideoPreviewLayer? {
        cameraService.previewLayer
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        cameraService.onPhotoCaptured = { [weak self] data in
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.capturedImage = image
                    self?.isPreviewing = true
                }
            }
        }
    }
    
    func setup() {
        cameraService.setup()
    }
    
    func start() {
        cameraService.start()
    }
    
    func stop() {
        cameraService.stop()
    }
    
    func capturePhoto() {
        cameraService.capturePhoto()
    }
    
    func retake() {
        capturedImage = nil
        isPreviewing = false
        overlayText = ""
        isEditingText = false
    }
    
    func save() {
        guard let image = capturedImage else { return }
        
        let finalImage = renderText(on: image)
        
        if let data = finalImage.jpegData(compressionQuality: 0.8) {
            cameraService.savePhoto(imageData: data)
        }
        retake()
    }
    
    private func renderText(on image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let renderedImage = renderer.image { context in
            image.draw(at: .zero)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 50),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedString = NSAttributedString(string: overlayText, attributes: attributes)
            let rect = CGRect(x: 0, y: image.size.height - 150, width: image.size.width, height: 100)
            attributedString.draw(in: rect)
        }
        
        return renderedImage
    }
}