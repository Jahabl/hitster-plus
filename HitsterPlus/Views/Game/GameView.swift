//
//  GameView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import MediaPlayer

struct GameView: View {
    @EnvironmentObject var manager: ViewManager
    
    let musicAccess: MPMediaLibraryAuthorizationStatus
    
    @State private var isShowingCamera: Bool = true
    @State private var foundSong: MPMediaItem? = nil
    @State private var phoneWasTurned: Bool = false
    
    var turnPhone: Bool
    var playWholeSong: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment.topTrailing) {
                QRScannerView(isShowingCamera: $isShowingCamera, foundSong: $foundSong)
                if !isShowingCamera && foundSong != nil {
                    if !phoneWasTurned && turnPhone {
                        TurnPhoneView(phoneWasTurned: $phoneWasTurned)
                    } else {
                        PlaySongView(song: foundSong!, turnPhone: turnPhone, playWholeSong: playWholeSong, isShowingCamera: $isShowingCamera, phoneWasTurned: $phoneWasTurned)
                    }
                } else if !isShowingCamera {
                    NotFoundView(isShowingCamera: $isShowingCamera)
                }
                Button {
                    manager.setView(view: AnyView(MainView(musicAccess: musicAccess, turnPhone: turnPhone, playWholeSong: playWholeSong).environmentObject(manager)))
                } label: {
                    Image(systemName: "multiply")
                }
                .buttonStyle(StyledButton(cornerRadius: 100))
                .padding(EdgeInsets(top: geometry.safeAreaInsets.top > 0 ? 0 : 15, leading: 0, bottom: 0, trailing: 15))
            }
        }
    }
}

#Preview {
    GameView(musicAccess: MPMediaLibraryAuthorizationStatus.denied, turnPhone: true, playWholeSong: false)
}
