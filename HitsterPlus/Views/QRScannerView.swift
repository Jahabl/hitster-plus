//
//  QRScannerView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import MediaPlayer
import VisionKit

struct QRScannerView: View {
    @Binding var isShowingCamera: Bool
    @Binding var foundSong: MPMediaItem?
    
    var body: some View {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            ZStack {
                Color("Background").ignoresSafeArea()
                DataScannerRepresentable(
                    shouldStartScanning: $isShowingCamera, foundSong: $foundSong
                )
                /*ZStack {
                    Color.black.opacity(0.5)
                    Rectangle().frame(width: 250, height: 250).blendMode(BlendMode.destinationOut)
                }
                .compositingGroup()*/
            }
            .ignoresSafeArea()
        } else if !DataScannerViewController.isSupported {
            Text("It looks like this device doesn't support the DataScannerViewController")
        } else {
            Text("It appears your camera may not be available")
        }
    }
}

#Preview {
    QRScannerView(isShowingCamera: Binding.constant(true), foundSong: Binding.constant(nil))
}
