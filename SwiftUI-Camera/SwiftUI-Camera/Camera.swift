//
//  Camera.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import AVFoundation
import UIKit

final class Camera: NSObject {
    var session: AVCaptureSession = .init()
    
    private var input: AVCaptureDeviceInput!
    private var output: AVCapturePhotoOutput = .init()
    
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
    private lazy var devices: [AVCaptureDevice] = {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        ).devices
    }()
    private lazy var frontPositionDevices: [AVCaptureDevice] = { devices.filter { $0.position == .front } }()
    private lazy var backPositionDevices: [AVCaptureDevice] = { devices.filter { $0.position == .back } }()
    
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
    
    func capture() {
        let photoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func switchPosition() {
        let position: AVCaptureDevice.Position = input.device.position == .back ? .front : .back
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .audio, position: position) else {
            return
        }
        do {
            input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        print(session.inputs)
    }
    
    private func savePhoto(_ data: Data) {
        guard let image = UIImage(data: data) else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        savePhoto(imageData)
    }
}
