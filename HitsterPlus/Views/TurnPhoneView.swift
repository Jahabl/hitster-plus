//
//  TurnPhoneView.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI

struct TurnPhoneView: View {
    @Binding var phoneWasTurned: Bool
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            Text("Turn Phone Description").multilineTextAlignment(TextAlignment.center).padding(30)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            let orientation: UIDeviceOrientation = UIDevice.current.orientation
            
            phoneWasTurned = orientation == UIDeviceOrientation.faceDown
        }
    }
}

#Preview {
    TurnPhoneView(phoneWasTurned: Binding.constant(false))
}
