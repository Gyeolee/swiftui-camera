//
//  CameraViewModel.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI
import Combine
import AVFoundation

@Observable
class CameraViewModel {
    private let camera: Camera = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var isSilentModeOn: Bool = false
    var isFlashOn: Bool = false
    var recentImage: UIImage?
    
    var cameraSession: AVCaptureSession {
        camera.session
    }
    
    init() {
        camera.$capturedImage
            .sink { self.recentImage = $0 }
            .store(in: &cancellables)
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
        await camera.start()
    }
    
    func capturePhoto() {
        camera.capture()
    }
    
    func switchCameraPosition() {
        camera.switchPosition()
    }
    
    func switchSilentMode() {
        isSilentModeOn.toggle()
        camera.isSilentModeOn = isSilentModeOn
    }
    
    func switchFlashOn() {
        isFlashOn.toggle()
        camera.flashMode = isFlashOn ? .on : .off
    }
}
