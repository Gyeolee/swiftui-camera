//
//  CameraPreviewView.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
//    let session: AVCaptureSession = .init()
    private let camera: Camera = .init()
    
    init() {
        camera.startSession()
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = PreviewView()
        view.backgroundColor = .black
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.cornerRadius = 0
        view.previewLayer.session = camera.session
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

// MARK: - Camera

fileprivate final class Camera {
    var session: AVCaptureSession = .init()
    
    private var input: AVCaptureDeviceInput!
    private var output: AVCapturePhotoOutput = .init()
    
    func startSession() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
//                output.isHighResolutionCaptureEnabled = true
                output.maxPhotoQualityPrioritization = .quality
            }
            
            session.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
}
