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
    
    @State var showingPopUP: Bool = false
    @State var inputText: String = ""
    
    func readInput() {
        if inputText.isEmpty {
            return
        }
        
        manager.setView(view: AnyView(GenerateCardsView(musicAccess: musicAccess, inputText: inputText, turnPhone: turnPhone, playWholeSong: playWholeSong).environmentObject(manager)))
    }
    
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
                    showingPopUP = true
                } label: {
                    HStack {
                        Text("Create Card Sheet")
                        Spacer()
                        Image(systemName: "printer")
                    }
                }
                .buttonStyle(StyledButton())
            }
            .padding(30)
            .blur(radius: showingPopUP ? 2.5 : 0)
            if showingPopUP {
                Color("Background").ignoresSafeArea().opacity(0.5)
                VStack(alignment: HorizontalAlignment.leading) {
                    Text("Playlist Name").font(Font.headline)
                    Text("Use songs in playlist to generate cards")
                    TextField("Playlist Name", text: $inputText, prompt: Text("Hitster")).modifier(StyledModifier())
                    Button {
                        readInput()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Generate")
                            Spacer()
                        }
                    }
                    .buttonStyle(StyledButton(tintColor: Color.accentColor))
                }
                .modifier(StyledModifier())
                .padding(30)
            }
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
