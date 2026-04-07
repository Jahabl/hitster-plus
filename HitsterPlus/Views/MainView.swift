//
//  MainView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import MediaPlayer
import VisionKit

struct MainView: View {
    @EnvironmentObject var manager: ViewManager
    
    let musicAccess: MPMediaLibraryAuthorizationStatus
    
    @State var turnPhone: Bool
    @State var playWholeSong: Bool
    
    @State private var playlist: MPMediaItemCollection?
    @State private var showingPicker: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                Spacer()
                Button {
                    manager.setView(view: AnyView(GameView(musicAccess: musicAccess, turnPhone: turnPhone, playWholeSong: playWholeSong).environmentObject(manager)))
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
                Button {
                    showingPicker = true
                } label: {
                    HStack {
                        Text("Create Card Sheet")
                        Spacer()
                        Image(systemName: "printer")
                    }
                }
                .buttonStyle(StyledButton())
                .sheet(isPresented: $showingPicker) {
                    MusicPicker(playlist: self.$playlist)
                }
                .onChange(of: playlist) { newList in
                    if newList != nil {
                        manager.setView(view: AnyView(GenerateCardsView(musicAccess: musicAccess, playlist: newList!, turnPhone: turnPhone, playWholeSong: playWholeSong).environmentObject(manager)))
                    }
                }
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
    MainView(musicAccess: MPMediaLibraryAuthorizationStatus.authorized, turnPhone: true, playWholeSong: false)
}
