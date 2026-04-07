//
//  StyledModifier.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 04.04.2026.
//

import Foundation
import SwiftUI

struct StyledModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .padding()
                .glassEffect(in: RoundedRectangle(cornerRadius: 25))
        } else {
            content
                .padding()
                .background(Color(white: 0.5, opacity: 0.15))
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}
