//
//  StyledButton.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI

struct StyledButton: ButtonStyle {
    var tintColor: Color = Color.clear
    var cornerRadius: CGFloat = 25
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .padding()
                .glassEffect(Glass.regular.tint(tintColor).interactive(), in: RoundedRectangle(cornerRadius: cornerRadius))
                .contentShape(Rectangle())
        } else {
            configuration.label
                .padding()
                .background(tintColor == Color.clear ? Color(white: 0.5, opacity: 0.15) : tintColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .contentShape(Rectangle())
        }
    }
}
