//
//  StyledImage.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 04.04.2026.
//

import SwiftUI

struct StyledImage: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(in: RoundedRectangle(cornerRadius: 25))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        } else {
            content
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}
