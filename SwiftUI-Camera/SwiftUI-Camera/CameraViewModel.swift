//
//  CameraViewModel.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI
import Combine
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published private(set) var isSilentModeOn: Bool = false
    @Published private(set) var isFlashOn: Bool = false
    @Published private(set) var recentImage: UIImage?
    
    var cameraSession: AVCaptureSession {
        camera.session
    }
    
    private let camera: Camera = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        camera.$isSilentModeOn
            .assign(to: \.isSilentModeOn, on: self)
            .store(in: &cancellables)
        
        camera.$flashMode
            .map { $0 == .on }
            .assign(to: \.isFlashOn, on: self)
            .store(in: &cancellables)
        
        camera.$capturedImage
            .assign(to: \.recentImage, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - 카메라 기능

extension CameraViewModel {
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
        camera.switchSilentMode()
    }
    
    func switchFlashOn() {
        camera.switchFlashMode()
    }
}

// MARK: - 카메라 권한 확인 및 요청

extension CameraViewModel {
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
}
