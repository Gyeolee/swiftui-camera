//
//  Camera.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import AVFoundation

final class Camera {
    var session: AVCaptureSession = .init()
    
    private var input: AVCaptureDeviceInput!
    private var output: AVCapturePhotoOutput = .init()
    
    func startSession() async {
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
