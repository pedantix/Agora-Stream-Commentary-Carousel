//
//  Graph.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/10/23.
//

import Foundation

// A very simple dependency injection container

class Graph: ObservableObject {
    let rtcManager: RTCManager
    let rtmpMediaPlayer: RTMPMediaPlayer
    
    @MainActor
    init() {
        rtcManager = RTCManager()
        rtmpMediaPlayer = .init(dependencies: rtcManager)
    }
}
