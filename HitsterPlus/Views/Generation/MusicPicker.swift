//
//  MusicPicker.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 06.04.2026.
//

import SwiftUI
import MediaPlayer

struct MusicPicker: UIViewControllerRepresentable {
    @Binding var playlist: MPMediaItemCollection?

    class Coordinator: NSObject, UINavigationControllerDelegate, MPMediaPickerControllerDelegate {
        var parent: MusicPicker

        init(_ parent: MusicPicker) {
            self.parent = parent
        }
        
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            parent.playlist = mediaItemCollection
            mediaPicker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MusicPicker>) -> MPMediaPickerController {
        let picker = MPMediaPickerController()
        picker.delegate = context.coordinator
        picker.allowsPickingMultipleItems = true
        
        return picker
    }

    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: UIViewControllerRepresentableContext<MusicPicker>) {

    }
}
