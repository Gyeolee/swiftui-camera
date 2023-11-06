//
//  CameraView.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI

struct CameraView: View {
    var viewModel: CameraViewModel = .init()
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.cameraSession)
                .task {
                    if await viewModel.authorizationStatus() {
                        await viewModel.startCamera()
                    }
                }
            
            VStack {
                HStack {
                    Button(action: viewModel.switchSilentMode) {
                        Image(systemName: viewModel.isSilentModeOn ? "speaker" : "speaker.fill")
                            .foregroundColor(viewModel.isSilentModeOn ? .white : .yellow)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: viewModel.switchFlashOn) {
                        Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt")
                            .foregroundColor(viewModel.isFlashOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                }
                .font(.system(size: 30))
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {  }) {
                        if let recentImage = viewModel.recentImage {
                            Image(uiImage: recentImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .aspectRatio(1, contentMode: .fit)
                                .padding()
                        } else {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth: 2)
                                .frame(width: 50, height: 50)
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.capturePhoto) {
                        Circle()
                            .stroke(lineWidth: 4)
                            .frame(width: 70, height: 70)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.switchCameraPosition) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    CameraView()
}
