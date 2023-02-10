//
//  RTCManager.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import AgoraRtcKit

@MainActor
class RTCManager: NSObject, ObservableObject, RTMPMediaPlayerDependcies {
    var engineKit: AgoraRtcEngineKit {
        return engine
    }
    
    private(set) var engine: AgoraRtcEngineKit!
    
    private var uids: Set<UInt> = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var myUid: UInt = 0 {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var mediaPlayPresentInChannel = false
    
    var sortedUids: [UInt] {
        return uids.sorted()
    }
    
    
    override init() {
        super.init()
        
        let config = AgoraRtcEngineConfig()
        config.appId = API.agoraAppID
        
        engine = .sharedEngine(with: config, delegate: self)
        engine.enableVideo()
    }
}

extension RTCManager {
    func joinChannel() {
        let mediaOptions = AgoraRtcChannelMediaOptions()
        mediaOptions.clientRoleType = .broadcaster
        let videoConfig = AgoraVideoEncoderConfiguration()
        // Set Framerate
        videoConfig.frameRate = AgoraVideoFrameRate.fps30
        engine.setVideoEncoderConfiguration(videoConfig)
        
        let status = engine.joinChannel(byToken: .none, channelId: "test", uid: myUid, mediaOptions: mediaOptions) { _, uid, _ in
             logger.info("Join success called, joined as \(uid)")
             self.myUid = uid
         }

         if status != 0 {
             logger.error("Error joining \(status)")
         }
    }
}

extension RTCManager {
    func setupCanvasFor(_ uiView: UIView, _ uid: UInt) {
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.renderMode = .hidden
        canvas.view = uiView
        if uid == myUid {
            engine.setupLocalVideo(canvas)
        } else {
            engine.setupRemoteVideo(canvas)
        }
    }
}

extension RTCManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        logger.error("Error \(errorCode.rawValue)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        logger.info("Joined \(channel) as uid \(uid)")
        myUid = uid
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        logger.info("other user joined as \(uid)")
        uids.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        logger.info("other user left with \(uid)")
        uids.remove(uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        logger.info("Incall stats fps \(stats.receivedFrameRate):\(stats.rendererOutputFrameRate):\(stats.decoderOutputFrameRate)")
    }
}
