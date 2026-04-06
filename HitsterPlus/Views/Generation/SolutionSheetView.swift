//
//  SolutionSheetView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 06.04.2026.
//

import SwiftUI
import MediaPlayer

struct SolutionSheetView: View {
    let songs: [MPMediaItem]
    let columns: Int
    
    func getRowAmount() -> Int {
        return Int(ceilf(Float(songs.count) / Float(columns)))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                ZStack {
                    Grid(alignment: Alignment.topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                        ForEach(0 ..< getRowAmount(), id: \.self) { i in
                            GridRow {
                                ForEach(0 ..< columns, id: \.self) { j in
                                    if i * columns + j < songs.count {
                                        ZStack {
                                            Color.white
                                            VStack {
                                                Text(songs[i * columns + j].artist ?? "Not Found").foregroundStyle(Color.black).multilineTextAlignment(TextAlignment.center).font(Font.system(size: geometry.size.width / 50, weight: Font.Weight.bold))
                                                    .frame(height: geometry.size.width / 4 / 3)
                                                Spacer()
                                                Text(songs[i * columns + j].title ?? "Not Found").foregroundStyle(Color.black).multilineTextAlignment(TextAlignment.center).italic().font(Font.system(size: geometry.size.width / 50))
                                                    .frame(height: geometry.size.width / 4 / 3)
                                            }
                                            .padding(geometry.size.width / 50)
                                            Text(String(Calendar(identifier: Calendar.Identifier.gregorian).component(Calendar.Component.year, from: songs[i * columns + j].releaseDate ?? Date.now))).foregroundStyle(Color.black).font(Font.system(size: geometry.size.width / 20, weight: Font.Weight.black))
                                        }
                                        .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                                        .overlay {
                                            Rectangle().stroke(Color.black, lineWidth: 0.5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width / 4 * CGFloat(columns), height: geometry.size.width / 4 * 5, alignment: Alignment.topLeading)
            }
        }
    }
}

#Preview {
    SolutionSheetView(songs: [], columns: 3)
}
