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
    
    init(images: [UIImage], columns: Int) {
        self.images = images
        self.columns = columns
        self.rows = Int(ceilf(Float(images.count) / Float(columns)))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                ZStack {
                    Grid(alignment: Alignment.topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                        ForEach(0 ..< rows, id: \.self) { i in
                            GridRow {
                                ForEach(0 ..< columns, id: \.self) { j in
                                    if i * columns + j < images.count {
                                        ZStack {
                                            Color.white
                                            Image(uiImage: images[i * columns + j]).resizable().interpolation(Image.Interpolation.none).frame(width: geometry.size.width / 8, height: geometry.size.width / 8)
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
    QRSheetView(images: [], columns: 3)
}
