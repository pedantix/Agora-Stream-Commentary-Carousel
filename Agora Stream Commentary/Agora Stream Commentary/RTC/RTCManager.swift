//
//  RTCManager.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import AgoraRtcKit

@MainActor
class RTCManager: NSObject, ObservableObject, RTMPMediaPlayerDependcies {
    static let broadcastUid: UInt = 0b0_1010
    var engineKit: AgoraRtcEngineKit {
        return engine
    }
    
    private var rtcConnection: AgoraRtcConnection?
    private weak var mediaPlayer: AgoraRtcMediaPlayerProtocol?
    private(set) var engine: AgoraRtcEngineKit!
    
    private var uids: Set<UInt> = [] {
        didSet {
            mediaPlayPresentInChannel = uids.contains(RTCManager.broadcastUid)
            if mediaPlayPresentInChannel {
                logger.info("media player in channel")
            }
            self.objectWillChange.send()
        }
    }
    @Published var myUid: UInt = 0 {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var mediaPlayPresentInChannel = false
    @Published var channelId = "TEST" {
        didSet {
            let strippedCapped = String(channelId.filter { $0.isNumber || $0.isLetter || $0.isSymbol }).uppercased()
        
            if channelId != strippedCapped {
                channelId = strippedCapped
            }
        }
    }
    var isBroadcaster: Bool {
        return mediaPlayer != nil
    }
    
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
        let status = engine.joinChannel(byToken: .none, channelId: channelId, uid: myUid, mediaOptions: mediaOptions) { _, uid, _ in
            logger.info("Join success called, joined as \(uid)")
            self.myUid = uid
            self.uids.insert(uid)
         }

         if status != 0 {
             logger.error("Error joining \(status)")
         }
    }
    
    func joinChannelForMediaPlayer(mediaPlayer: AgoraRtcMediaPlayerProtocol) {
        self.mediaPlayer = mediaPlayer
        self.mediaPlayer?.play()
        let connection = AgoraRtcConnection()
        connection.channelId = channelId
        connection.localUid = RTCManager.broadcastUid
        let mediaOptions = AgoraRtcChannelMediaOptions()
        mediaOptions.clientRoleType = .broadcaster
        mediaOptions.channelProfile = .liveBroadcasting
        mediaOptions.publishMediaPlayerAudioTrack = true
        mediaOptions.publishMediaPlayerVideoTrack = true
        mediaOptions.publishMicrophoneTrack = false
        mediaOptions.publishCameraTrack = false
        mediaOptions.publishMediaPlayerId = Int(mediaPlayer.getMediaPlayerId())
        
        let status = engine.joinChannelEx(byToken: .none, connection: connection, delegate: self, mediaOptions: mediaOptions)
        if status != 0 {
            logger.error("Error joining \(status) as comentator broadcasting")
        }
        self.rtcConnection = connection
    }
    
    func leaveChannel() {
        logger.info("leave channel called")
        if let mp = mediaPlayer {
            mp.stop()
            engine.destroyMediaPlayer(mp)
        }
        if let rtcConnection = rtcConnection {
            engine.leaveChannelEx(rtcConnection) { _ in
                logger.info("Left the player channel")
            }
        }
        engine.leaveChannel() { _ in
            logger.info("Left the broadcast channel")
            self.uids.removeAll()
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
        logger.info("Other user joined \(channel) as uid \(uid)")
        uids.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        logger.info("other user joined as \(uid)")
        if uid == RTCManager.broadcastUid && isBroadcaster {
            mediaPlayer?.play()
        }
        uids.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        logger.info("other user left with \(uid)")
        uids.remove(uid)
    }
    
    /*func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        logger.info("Incall stats fps \(stats.receivedFrameRate):\(stats.rendererOutputFrameRate):\(stats.decoderOutputFrameRate)")
    }*/
}
