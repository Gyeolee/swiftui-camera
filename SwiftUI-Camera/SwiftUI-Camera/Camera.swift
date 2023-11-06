//
//  Camera.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import AVFoundation
import UIKit
import SwiftUI

final class Camera: NSObject, ObservableObject {
    var session: AVCaptureSession = .init()
    var isSilentModeOn: Bool = false
    var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var capturedImage: UIImage?
    
    private var input: AVCaptureDeviceInput!
    private var output: AVCapturePhotoOutput = .init()
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let deviceTypes: [AVCaptureDevice.DeviceType] = [
        .external,
        .microphone,
        .builtInWideAngleCamera,
        .builtInTelephotoCamera,
        .builtInUltraWideCamera,
        .builtInDualCamera,
        .builtInDualWideCamera,
        .builtInTrueDepthCamera,
        .builtInLiDARDepthCamera,
        .continuityCamera
    ]
    
    private var devices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified).devices
    }
    private var frontPositionDevices: [AVCaptureDevice] {
        devices.filter { $0.position == .front }
    }
    private var backPositionDevices: [AVCaptureDevice] {
        devices.filter { $0.position == .back }
    }
    
    func start() async {
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
                output.maxPhotoQualityPrioritization = .quality
            }
            
            session.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func capture() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = flashMode
        
        output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func switchPosition() {
        let position: AVCaptureDevice.Position
        switch input.device.position {
        case .unspecified:  position = .back
        case .back:         position = .front
        case .front:        position = .back
        @unknown default:   fatalError()
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            return
        }
        do {
            input = try AVCaptureDeviceInput(device: device)
            session.beginConfiguration()
            
            if let inputs = session.inputs as? [AVCaptureDeviceInput] {
                inputs.forEach {
                    session.removeInput($0)
                }
            }
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func savePhoto(_ data: Data) {
        guard let image = UIImage(data: data) else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        feedbackGenerator.impactOccurred()
        
        if isSilentModeOn {
            AudioServicesDisposeSystemSoundID(1108)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("didCapturePhotoFor")
        
        if isSilentModeOn {
            AudioServicesDisposeSystemSoundID(1108)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        savePhoto(imageData)
        capturedImage = UIImage(data: imageData)
    }
}
