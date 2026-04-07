//
//  HitsterPlusApp.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import MediaPlayer

@main
struct HitsterPlusApp: App {
    @StateObject var manager: ViewManager = ViewManager()
    
    @State var isLoading: Bool = true
    
    private let musicAccess: MPMediaLibraryAuthorizationStatus
    
    private var turnPhone: Bool
    private var playWholeSong: Bool
    
    init() {
        turnPhone = !UserDefaults.standard.bool(forKey: "noPhoneTurn")
        playWholeSong = UserDefaults.standard.bool(forKey: "playWholeSong")
        
        musicAccess = MPMediaLibrary.authorizationStatus()
    }
    
    func prepareApp() {
        switch musicAccess {
        case MPMediaLibraryAuthorizationStatus.authorized:
            print("authorized")
        case MPMediaLibraryAuthorizationStatus.denied:
            print("denied")
        case MPMediaLibraryAuthorizationStatus.notDetermined:
            print("not determined")
            MPMediaLibrary.requestAuthorization() { granted in
                if granted != MPMediaLibraryAuthorizationStatus.authorized {
                    return
                }
            }
        case MPMediaLibraryAuthorizationStatus.restricted:
            print("restricted")
        @unknown default:
            print("default")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                Text("Loading")
                .task {
                    prepareApp()
                    manager.setView(view: AnyView(MainView(musicAccess: musicAccess, turnPhone: turnPhone, playWholeSong: playWholeSong).environmentObject(manager)))
                    isLoading = false
                }
            } else {
                manager.getCurrentView()
            }
        }
    }
}
