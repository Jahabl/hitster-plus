//
//  ViewManager.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 05.04.2026.
//

import SwiftUI
internal import Combine

class ViewManager: ObservableObject {
    @Published var currentView: AnyView = AnyView(Color("Background").ignoresSafeArea())
    
    func setView(view: AnyView) {
        DispatchQueue.main.async {
            self.currentView = AnyView(view)
        }
    }
    
    func getCurrentView() -> AnyView {
        return currentView
    }
}
