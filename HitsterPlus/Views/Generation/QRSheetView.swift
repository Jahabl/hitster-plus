//
//  QRSheetView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 05.04.2026.
//

import SwiftUI

struct QRSheetView: View {
    let images: [UIImage]
    let columns: Int
    let rows: Int
    let maxRows: Int
    
    init(images: [UIImage], columns: Int, rows: Int) {
        self.images = images
        self.columns = columns
        self.rows = rows
        
        self.maxRows = Int(ceilf(Float(images.count) / Float(columns)))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                ZStack {
                    VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                        ForEach(0 ..< maxRows, id: \.self) { i in
                            HStack(spacing: 0) {
                                ForEach(0 ..< columns, id: \.self) { j in
                                    if i * columns + j < images.count {
                                        ZStack {
                                            Color.white
                                            Image(uiImage: images[i * columns + j]).resizable().interpolation(Image.Interpolation.none).frame(width: geometry.size.width / 6.5, height: geometry.size.width / 6.5)
                                        }
                                        .frame(width: geometry.size.width / 3.25, height: geometry.size.width / 3.25)
                                        .overlay {
                                            Rectangle().stroke(Color.black, lineWidth: 0.5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width / 3.25 * CGFloat(columns), height: geometry.size.width / 3.25 * CGFloat(rows), alignment: Alignment.topLeading)
            }
        }
    }
}

#Preview {
    QRSheetView(images: [], columns: 3, rows: 5)
}
