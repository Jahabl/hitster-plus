//
//  GenerateCardsView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 05.04.2026.
//

import SwiftUI
import MediaPlayer
import CoreImage.CIFilterBuiltins
internal import Combine

struct GenerateCardsView: View {
    @EnvironmentObject var manager: ViewManager
    @Environment(\.displayScale) var displayScale
    
    let musicAccess: MPMediaLibraryAuthorizationStatus
    let inputText: String
    
    var turnPhone: Bool
    var playWholeSong: Bool
    
    @State var capture: UIImage?
    
    let context: CIContext = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var cardSheets: [AnyView] = []
    @State var renderedImages: [UIImage] = []
    
    @State var showShare: Bool = false
    
    let a4Size: CGSize = CGSize(width: 2480, height: 3508) //300 DPI
    
    func createPreviews(currPlaylist: MPMediaItemCollection) {
        let sheets: Int = Int(ceilf(Float(currPlaylist.items.count) / 15))
        
        for sheet in 0 ..< sheets {
            var images: [UIImage] = []
            var songs: [MPMediaItem] = []
            var index: Int = sheet * 15
            
            while index < (sheet + 1) * 15 && index < currPlaylist.items.count {
                if let songTitle: String = currPlaylist.items[index].title {
                    images.append(generateQRCode(text: songTitle))
                    songs.append(currPlaylist.items[index])
                }
                
                index += 1
            }
            
            cardSheets.append(AnyView(QRSheetView(images: images, columns: 3, rows: 5)))
            cardSheets.append(AnyView(SolutionSheetView(songs: songs, columns: 3, rows: 5)))
        }
    }
    
    func generateQRCode(text: String) -> UIImage {
        filter.message = Data(text.utf8)
        
        if let outputImage: CIImage = filter.outputImage {
            if let cgImage: CGImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment.topTrailing) {
                Color("Background").ignoresSafeArea()
                ScrollView {
                    VStack {
                        ForEach(0 ..< cardSheets.count, id: \.self) { i in
                            cardSheets[i].frame(width: geometry.size.width, height: round(geometry.size.width * 1.4142135623731)).clipped()
                        }
                    }
                }
                VStack {
                    Spacer()
                    if cardSheets.isEmpty {
                        Text("No card sheets generated")
                        Spacer()
                    }
                    else {
                        Button {
                            showShare = true
                        } label: {
                            Text("Export Images")
                        }
                        .sheet(isPresented: $showShare) {
                            ShareView(items: renderedImages)
                        }
                        .buttonStyle(StyledButton())
                    }
                }
                .frame(width: geometry.size.width)
                Button {
                    manager.setView(view: AnyView(MainView(musicAccess: musicAccess, turnPhone: turnPhone, playWholeSong: playWholeSong).environmentObject(manager)))
                } label: {
                    Image(systemName: "multiply")
                }
                .buttonStyle(StyledButton(cornerRadius: 100))
                .padding(EdgeInsets(top: geometry.safeAreaInsets.top > 0 ? 0 : 15, leading: 0, bottom: 0, trailing: 15))
            }
        }
        .task {
            let playlists: [MPMediaItemCollection]? = MPMediaQuery.playlists().collections
            
            if playlists == nil {
                return
            }
            
            let currPlaylist: MPMediaItemCollection? = playlists!.first { playlist in
                if let playlistName: String = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String {
                    return playlistName.caseInsensitiveCompare(inputText) == ComparisonResult.orderedSame
                }
                else {
                    return false
                }
            }
            
            if currPlaylist == nil {
                return
            }
            
            createPreviews(currPlaylist: currPlaylist!)
            
            for sheet in cardSheets {
                let renderer = ImageRenderer(content: sheet.frame(width: a4Size.width, height: a4Size.height))
                renderedImages.append(renderer.uiImage!)
            }
            
            /*let renderer = ImageRenderer(content: qrSheet)
            renderer.scale = displayScale
            
            if renderer.uiImage != nil {
                renderedImage = renderer.uiImage!
            }*/
        }
    }
}

#Preview {
    GenerateCardsView(musicAccess: MPMediaLibraryAuthorizationStatus.authorized, inputText: "Hitster", turnPhone: true, playWholeSong: false)
}

struct ShareView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
