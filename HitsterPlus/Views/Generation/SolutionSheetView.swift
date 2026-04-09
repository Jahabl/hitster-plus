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
    let rows: Int
    let maxRows: Int
    
    init(songs: [MPMediaItem], columns: Int, rows: Int) {
        self.songs = songs
        self.columns = columns
        self.rows = rows
        
        self.maxRows = Int(ceilf(Float(songs.count) / Float(columns)))
    }
    
    func getReleaseYear(from song: MPMediaItem) -> String {
        if let date: Date = song.releaseDate {
            return String(Calendar(identifier: Calendar.Identifier.gregorian).component(Calendar.Component.year, from: date))
        }
        
        if let yearNumber: NSNumber = song.value(forProperty: "year") as? NSNumber {
            if (yearNumber.isKind(of: NSNumber.self)) {
                let year = yearNumber.intValue
                
                if (year != 0) {
                    return String(year)
                } else {
                    return String(Calendar(identifier: Calendar.Identifier.gregorian).component(Calendar.Component.year, from: Date.now))
                }
            }
        }
        
        return String(Calendar(identifier: Calendar.Identifier.gregorian).component(Calendar.Component.year, from: Date.now))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                ZStack {
                    VStack(alignment: HorizontalAlignment.trailing, spacing: 0) {
                        ForEach(0 ..< maxRows, id: \.self) { i in
                            HStack(spacing: 0) {
                                ForEach(0 ..< columns, id: \.self) { j in
                                    if i * columns + (columns - j - 1) < songs.count {
                                        ZStack {
                                            Color.white
                                            VStack {
                                                Text(songs[i * columns + (columns - j - 1)].artist ?? "Not Found").foregroundStyle(Color.black).multilineTextAlignment(TextAlignment.center).font(Font.system(size: geometry.size.width / 50, weight: Font.Weight.bold))
                                                    .frame(height: geometry.size.width / 11.1)
                                                Spacer()
                                                Text(songs[i * columns + (columns - j - 1)].title ?? "Not Found").foregroundStyle(Color.black).multilineTextAlignment(TextAlignment.center).italic().font(Font.system(size: geometry.size.width / 50))
                                                    .frame(height: geometry.size.width / 11.1)
                                            }
                                            .padding(geometry.size.width / 50)
                                            Text(getReleaseYear(from: songs[i * columns + (columns - j - 1)])).foregroundStyle(Color.black).font(Font.system(size: geometry.size.width / 20, weight: Font.Weight.black))
                                        }
                                        .frame(width: geometry.size.width / 3.7, height: geometry.size.width / 3.7)
                                        .overlay {
                                            Rectangle().stroke(Color.black, lineWidth: 0.5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width / 3.7 * CGFloat(columns), height: geometry.size.width / 3.7 * CGFloat(rows), alignment: Alignment.topTrailing)
            }
        }
    }
}

#Preview {
    SolutionSheetView(songs: [], columns: 3, rows: 4)
}
