//
//  CameraView.swift
//  SwiftUI-Camera
//
//  Created by Hangyeol on 11/3/23.
//

import SwiftUI

struct CameraView: View {
    @State private var isFlashOn: Bool = false
    @State private var isSilentModeOn: Bool = false
    
    var body: some View {
        ZStack {
            CameraPreviewView()
            
            VStack {
                HStack {
                    Button(action: { isFlashOn.toggle() }) {
                        Image(systemName: isFlashOn ? "speaker.fill" : "speaker")
                            .foregroundColor(isFlashOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                    
                    // 플래시 온오프
                    Button(action: { isSilentModeOn.toggle() }) {
                        Image(systemName: isSilentModeOn ? "bolt.fill" : "bolt")
                            .foregroundColor(isSilentModeOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                }
                .font(.system(size:25))
                .padding()
                
                Spacer()
                
                HStack{
                    Button(action: {  }) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 5)
                            .frame(width: 75, height: 75)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {  }) {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 75, height: 75)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {  }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                    }
                    .frame(width: 75, height: 75)
                    .padding()
                }
            }
            .foregroundColor(.white)
        }
//        .background(.black) // 임시
    }
}

#Preview {
    CameraView()
}
