//
//  CameraViewModel.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI
import AVFoundation

@Observable class CameraViewModel {
    private let camera: Camera = .init()
    
    var cameraSession: AVCaptureSession {
        camera.session
    }
    
    func authorizationStatus() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined, .denied:
            return await AVCaptureDevice.requestAccess(for: .video)
            
        case .authorized:
            return true

        case .restricted:
            return false

        @unknown default:
            return false
        }
    }
    
    func startCamera() async {
        await camera.startSession()
    }
}
