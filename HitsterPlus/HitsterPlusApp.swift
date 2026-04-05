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
    private let musicAccess: MPMediaLibraryAuthorizationStatus
    
    @State private var turnPhone: Bool
    @State private var playWholeSong: Bool
    
    init() {
        turnPhone = !UserDefaults.standard.bool(forKey: "noPhoneTurn")
        playWholeSong = UserDefaults.standard.bool(forKey: "playWholeSong")
        
        musicAccess = MPMediaLibrary.authorizationStatus()
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
            ContentView(musicAccess: musicAccess, turnPhone: $turnPhone, playWholeSong: $playWholeSong)
        }
    }
}
