//
//  DataScannerRepresentable.swift
//  HitsterPlus
//
//  Created by Janice Hablützel on 03.04.2026.
//

import SwiftUI
import VisionKit
import MediaPlayer
import Vision

struct DataScannerRepresentable: UIViewControllerRepresentable {
    @Binding var shouldStartScanning: Bool
    @Binding var foundSong: MPMediaItem?
    
    var dataToScanFor: Set<DataScannerViewController.RecognizedDataType> = [DataScannerViewController.RecognizedDataType.barcode(symbologies: [VNBarcodeSymbology.qr]), DataScannerViewController.RecognizedDataType.text(languages: ["en-US", "de-DE"])]
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScannerRepresentable
        let feedbackGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
        
        init(_ parent: DataScannerRepresentable) {
            self.parent = parent
            
            feedbackGenerator.prepare()
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processAddedItems(items: addedItems)
        }
        
        func processAddedItems(items: [RecognizedItem]) {
            for item in items {
                processItem(item: item)
            }
        }
        
        func processItem(item: RecognizedItem) {
            switch item {
            case .barcode(let code):
                let songs: [MPMediaItem]? = MPMediaQuery.songs().items
                
                if songs == nil {
                    parent.foundSong = nil
                    feedbackGenerator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
                    parent.shouldStartScanning = false
                    
                    return
                }
                
                let scannedText: String = code.payloadStringValue ?? ""
                
                parent.foundSong = songs!.first { song in
                    song.title?.caseInsensitiveCompare(scannedText) == ComparisonResult.orderedSame
                }
                
                feedbackGenerator.notificationOccurred(parent.foundSong == nil ? UINotificationFeedbackGenerator.FeedbackType.error : UINotificationFeedbackGenerator.FeedbackType.success)
                parent.shouldStartScanning = false
            case .text(_):
                break
            @unknown default:
                print("Should not happen")
            }
        }
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerVC = DataScannerViewController(
            recognizedDataTypes: dataToScanFor,
            qualityLevel: DataScannerViewController.QualityLevel.accurate,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        
        dataScannerVC.delegate = context.coordinator
        
        return dataScannerVC
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if shouldStartScanning {
            try? uiViewController.startScanning()
        } else {
            uiViewController.stopScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
