//
//  Agora_Stream_CommentaryApp.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import SwiftUI

@main
struct Agora_Stream_CommentaryApp: App {
    @StateObject private var graph = Graph()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(graph.rtcManager)
                .environmentObject(graph.rtmpMediaPlayer)
        }
    }
}
