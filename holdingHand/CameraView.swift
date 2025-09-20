import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.viewModel = viewModel
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
    }

    class CameraViewController: UIViewController {
        var viewModel: CameraViewModel?

        override func viewDidLoad() {
            super.viewDidLoad()

            if let previewLayer = viewModel?.previewLayer {
                view.layer.addSublayer(previewLayer)
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            viewModel?.previewLayer?.frame = view.bounds
        }
    }
}
