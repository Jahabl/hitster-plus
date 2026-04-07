//
//  GenerateCardsView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 05.04.2026.
//

import SwiftUI
import MediaPlayer
import CoreImage.CIFilterBuiltins

struct GenerateCardsView: View {
    @EnvironmentObject var manager: ViewManager
    @Environment(\.displayScale) var displayScale
    
    let musicAccess: MPMediaLibraryAuthorizationStatus
    let playlist: MPMediaItemCollection
    
    var turnPhone: Bool
    var playWholeSong: Bool
    
    @State var capture: UIImage?
    
    let context: CIContext = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var cardSheets: [AnyView] = []
    @State var pdfURL: URL?
    
    @State var showShare: Bool = false
    
    let a4Size: CGSize = CGSize(width: 2480, height: 3508) //300 DPI
    
    func createPreviews(from currPlaylist: MPMediaItemCollection) {
        var playlist: [MPMediaItem] = currPlaylist.items
        playlist = Array(Set(playlist))
        
        let sheets: Int = Int(ceilf(Float(playlist.count) / 12))
        
        for sheet in 0 ..< sheets {
            var images: [UIImage] = []
            var songs: [MPMediaItem] = []
            var index: Int = sheet * 12
            
            while index < (sheet + 1) * 12 && index < playlist.count {
                if let songTitle: String = playlist[index].title {
                    images.append(generateQRCode(from: songTitle))
                    songs.append(playlist[index])
                }
                
                index += 1
            }
            
            cardSheets.append(AnyView(QRSheetView(images: images, columns: 3, rows: 4)))
            cardSheets.append(AnyView(SolutionSheetView(songs: songs, columns: 3, rows: 4)))
        }
    }
    
    func generateQRCode(from text: String) -> UIImage {
        filter.message = Data(text.utf8)
        
        if let outputImage: CIImage = filter.outputImage {
            if let cgImage: CGImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func createPDF(from views: [AnyView]) -> URL {
        let url: URL = FileManager.default.temporaryDirectory.appendingPathComponent("cardSheet.pdf")
        
        var mediaBox: CGRect = CGRect(origin: CGPoint.zero, size: a4Size)
        
        guard let context: CGContext = CGContext(url as CFURL, mediaBox: &mediaBox, nil) else {
            fatalError("Could not create PDF context")
        }
        
        for view in views {
            let renderer = ImageRenderer(content: view.frame(width: a4Size.width, height: a4Size.height))
            
            renderer.scale = 1
            context.beginPDFPage(nil)
            renderer.render { size, renderContext in
                renderContext(context)
            }
            
            context.endPDFPage()
        }
        
        context.closePDF()
        
        return url
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
                    } else {
                        ShareLink(item: pdfURL!) {
                            Label("Export PDF", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(StyledButton())
                        .padding(30)
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
            createPreviews(from: playlist)
            pdfURL = createPDF(from: cardSheets)
        }
    }
}

#Preview {
    GenerateCardsView(musicAccess: MPMediaLibraryAuthorizationStatus.authorized, playlist: MPMediaItemCollection(), turnPhone: true, playWholeSong: false)
}

struct ShareView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
