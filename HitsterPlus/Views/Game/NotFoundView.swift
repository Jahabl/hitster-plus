//
//  NotFoundView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI

struct NotFoundView: View {
    @Binding var isShowingCamera: Bool
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                Spacer()
                Text("Invalid QR code")
                Spacer()
                Button {
                    isShowingCamera = true
                } label: {
                    HStack {
                        Text("Try Again")
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .buttonStyle(StyledButton(tintColor: Color.accentColor))
            }
            .padding(30)
        }
    }
}

#Preview {
    NotFoundView(isShowingCamera: Binding.constant(false))
}
