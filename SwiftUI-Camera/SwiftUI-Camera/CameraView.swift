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
                    Button(action: viewModel.switchFlashOn) {
                        Image(systemName: viewModel.isFlashOn ? "speaker.fill" : "speaker")
                            .foregroundColor(viewModel.isFlashOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: viewModel.switchSilentMode) {
                        Image(systemName: viewModel.isSilentModeOn ? "bolt.fill" : "bolt")
                            .foregroundColor(viewModel.isSilentModeOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                }
                .font(.system(size:25))
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {  }) {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                            .frame(width: 40, height: 40)
                            .padding()
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
