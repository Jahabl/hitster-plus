//
//  PlaySongView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import AVFAudio
import AVFoundation
import MediaPlayer

struct PlaySongView: View {
    let song: MPMediaItem
    let turnPhone: Bool
    let playWholeSong: Bool
    
    @State private var songMax: Int = 30
    
    @Binding var isShowingCamera: Bool
    @Binding var phoneWasTurned: Bool
    
    @State private var musicPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false
    @State private var musicTimer: Timer?
    
    @State private var secondsPlayed: Int = 0
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                Spacer()
                if turnPhone {
                    if song.artwork != nil {
                        Image(uiImage: song.artwork!.image(at: CGSize(width: 250, height: 250))!).resizable().frame(width: 250, height: 250).modifier(StyledImage())
                    }
                    Text(song.title ?? "Not Found").font(Font.headline)
                    Text(song.artist ?? "Not Found")
                    //Text(String(Calendar(identifier: Calendar.Identifier.gregorian).component(Calendar.Component.year, from: song.releaseDate ?? Date.now)))
                }
                if secondsPlayed <= songMax {
                    Button {
                        if isPlaying {
                            isPlaying = false
                            musicPlayer?.pause()
                        } else {
                            musicPlayer?.play()
                            isPlaying = true
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "multiply").opacity(0)
                            Image(systemName: isPlaying ? "pause" : "play")
                        }
                        //Image(systemName: "keyboard").font(.largeTitle.weight(.black))
                    }
                    .buttonStyle(StyledButton(cornerRadius: 100))
                } else {
                    Button {
                        secondsPlayed = 0
                        
                        if !playWholeSong {
                            musicPlayer?.currentTime = song.playbackDuration / 3 * 2
                        } else {
                            musicPlayer?.currentTime = 0
                        }
                        
                        musicPlayer?.play()
                        isPlaying = true
                    } label: {
                        Image(systemName: "goforward")
                    }
                    .buttonStyle(StyledButton(cornerRadius: 100))
                }
                Spacer()
                Button {
                    phoneWasTurned = false
                    isShowingCamera = true
                } label: {
                    HStack {
                        Text("Next Card")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(StyledButton(tintColor: Color.accentColor))
            }
            .padding(30)
        }
        .onAppear {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: song.assetURL!)
                if !playWholeSong {
                    musicPlayer?.currentTime = song.playbackDuration / 3 * 2
                } else {
                    songMax = Int(ceil(song.playbackDuration))
                }
                
                musicPlayer?.play()
                isPlaying = ((musicPlayer?.isPlaying) != nil)
                
                musicTimer = Timer(timeInterval: 1, repeats: true, block: { timer in
                    if isPlaying {
                        secondsPlayed += 1
                        
                        if secondsPlayed > songMax {
                            print("finished")
                            isPlaying = false
                            musicPlayer?.pause()
                        }
                    }
                })
                
                RunLoop.current.add(musicTimer!, forMode: RunLoop.Mode.common) //can't be in task
            } catch {
                print("\(error)")
            }
        }
        .onDisappear {
            musicTimer?.invalidate()
        }
    }
}
