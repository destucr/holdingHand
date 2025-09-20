import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)

            if viewModel.isPreviewing {
                ZStack {
                    Color.black.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Spacer()
                        ZStack {
                            if let image = viewModel.capturedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 300)
                                    .cornerRadius(20)
                            }
                            
                            Text(viewModel.overlayText)
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        if viewModel.isEditingText {
                            TextField("Enter text...", text: $viewModel.overlayText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                        
                        Spacer()

                        HStack(spacing: 60) {
                            Button(action: {
                                viewModel.retake()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                viewModel.isEditingText.toggle()
                            }) {
                                Image(systemName: "text.bubble.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }

                            Button(action: {
                                viewModel.save()
                            }) {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.capturePhoto()
                    }) {
                        Image(systemName: "circle.inset.filled")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {
            viewModel.setup()
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}