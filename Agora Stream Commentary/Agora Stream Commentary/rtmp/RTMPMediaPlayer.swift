//
//  RTMPValidator.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/9/23.
//


import AgoraRtcKit
import Foundation


protocol RTMPMediaPlayerDependcies {
    @MainActor var engineKit: AgoraRtcEngineKit { get }
}


@MainActor
class RTMPMediaPlayer: NSObject, ObservableObject {
    init(dependencies: RTMPMediaPlayerDependcies) {
        self.engine = dependencies.engineKit
        super.init()
    }
    
    var engine: AgoraRtcEngineKit
    
    @Published var isValid = false
    @Published var isInvalidEntry = false
    @Published var isValidating = false
    
    var mediaPlayer: AgoraRtcMediaPlayerProtocol?
    
    
    @Published var rtmpString = "" {
        didSet {
            isValid = false
            isInvalidEntry = false
        }
    }
    
    func validate() {
        mediaPlayer = engine.createMediaPlayer(with: self)
        let value = mediaPlayer?.open(rtmpString, startPos: 0)
        if value == 0 {
            isValidating = true
        } else {
            logger.info("value of open is \(value ?? 0)")
        }
    }
}


extension RTMPMediaPlayer: AgoraRtcMediaPlayerDelegate {
    func AgoraRtcMediaPlayer(_ playerKit: AgoraRtcMediaPlayerProtocol, didChangedTo state: AgoraMediaPlayerState, error: AgoraMediaPlayerError) {
        Task {
            await handleStateChange(state: state)
        }
    }
    
    @MainActor
    private func handleStateChange(state: AgoraMediaPlayerState) async {
        switch state {
        case .openCompleted:
            isValid = true
        case .failed:
            isInvalidEntry = true
            isValid = false
        case .doNothingInternal, .idle, .gettingInternal, .noneInternal, .opening, .paused, .pausingInternal, .playBackAllLoopsCompleted,
                .stopped, .stoppingInternal, .playing, .playBackCompleted, .setTrackInternal, .seekingInternal:
            break
        @unknown default:
            break
        }
        
        isValidating = false
    }
}
