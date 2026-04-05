//
//  ContentView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    public let musicAccess: MPMediaLibraryAuthorizationStatus
    
    @State private var isPlayingGame: Bool = false
    @State private var isShowingCamera: Bool = false
    @State private var foundSong: MPMediaItem?
    @State private var phoneWasTurned: Bool = false
    
    @Binding var turnPhone: Bool
    @Binding var playWholeSong: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment.topTrailing) {
                QRScannerView(isShowingCamera: $isShowingCamera, foundSong: $foundSong)
                if !isShowingCamera && !isPlayingGame {
                    StartGameView(musicAccess: musicAccess, isPlayingGame: $isPlayingGame, isShowingCamera: $isShowingCamera, turnPhone: $turnPhone, playWholeSong: $playWholeSong)
                }
                else if !isShowingCamera && foundSong != nil {
                    if !phoneWasTurned && turnPhone {
                        TurnPhoneView(phoneWasTurned: $phoneWasTurned)
                    }
                    else {
                        PlaySongView(song: foundSong!, turnPhone: turnPhone, playWholeSong: playWholeSong, isShowingCamera: $isShowingCamera, phoneWasTurned: $phoneWasTurned)
                    }
                }
                else if !isShowingCamera {
                    NotFoundView(isShowingCamera: $isShowingCamera)
                }
                if isPlayingGame {
                    Button {
                        isPlayingGame = false
                        isShowingCamera = false
                        phoneWasTurned = false
                        foundSong = nil
                    } label: {
                        Image(systemName: "multiply")
                    }
                    .buttonStyle(StyledButton(cornerRadius: 100))
                    .padding(EdgeInsets(top: geometry.safeAreaInsets.top > 0 ? 0 : 15, leading: 0, bottom: 0, trailing: 15))
                }
            }
        }
    }
}

#Preview {
    ContentView(musicAccess: MPMediaLibraryAuthorizationStatus.denied, turnPhone: Binding.constant(true), playWholeSong: Binding.constant(false))
}
