//
//  StartGameView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import MediaPlayer
import VisionKit

struct StartGameView: View {
    let musicAccess: MPMediaLibraryAuthorizationStatus
    
    @Binding var isPlayingGame: Bool
    @Binding var isShowingCamera: Bool
    
    @Binding var turnPhone: Bool
    @Binding var playWholeSong: Bool
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                Spacer()
                Button {
                    isPlayingGame = true
                    isShowingCamera = true
                } label: {
                    HStack {
                        Text("Start Game")
                        Image(systemName: "play")
                    }
                }
                .buttonStyle(StyledButton(tintColor: Color.accentColor)).disabled(musicAccess != MPMediaLibraryAuthorizationStatus.authorized || !DataScannerViewController.isSupported || !DataScannerViewController.isAvailable)
                Spacer()
                VStack(alignment: HorizontalAlignment.leading) {
                    Toggle(isOn: $turnPhone) {
                        Text("Turn Phone")
                    }
                    .tint(Color.accentColor)
                    Divider()
                    Toggle(isOn: $playWholeSong) {
                        Text("Whole Song")
                    }
                    .tint(Color.accentColor)
                }
                .modifier(StyledModifier())
            }
            .padding(30)
        }
        .onDisappear {
            UserDefaults.standard.set(!turnPhone, forKey: "noPhoneTurn")
            UserDefaults.standard.set(playWholeSong, forKey: "playWholeSong")
        }
    }
}

#Preview {
    StartGameView(musicAccess: MPMediaLibraryAuthorizationStatus.authorized, isPlayingGame: Binding.constant(false), isShowingCamera: Binding.constant(false), turnPhone: Binding.constant(true), playWholeSong: Binding.constant(false))
}
