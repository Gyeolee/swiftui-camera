//
//  CameraPreviewView.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> some UIView {
        let view = PreviewView()
        view.backgroundColor = .black
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.cornerRadius = 0
        view.previewLayer.session = session
//        view.previewLayer.connection?.videoOrientation = .portrait
        view.previewLayer.connection?.videoRotationAngle = .infinity
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

// MARK: - UIView

extension CameraPreviewView {
    private final class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
}
