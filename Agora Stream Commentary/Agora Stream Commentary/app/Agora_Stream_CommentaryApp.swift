//
//  Agora_Stream_CommentaryApp.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import AVKit
import SwiftUI

@main
struct Agora_Stream_CommentaryApp: App {
    @StateObject private var graph = Graph()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(graph.rtcManager)
                .environmentObject(graph.rtmpMediaPlayer)
                .onAppear {
                    Task {
                        let videoAuth = await authorizeApp(for: .video)
                        let audioAuth = await authorizeApp(for: .audio)
                        logger.info("Audio Authorization Status \(audioAuth), Video Auth Status \(videoAuth)")
                    }
                }
        }
    }
    
    private func authorizeApp(for type: AVMediaType) async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: type)
        switch status {
        case .authorized:
            logger.info("\(type) Authorized")
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: type)
        default:
            logger.error("Video not authorized were this not a demo this would need to be handled in the UI")
            return false
        }
    }
}
