//
//  CommentaryView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import SwiftUI

struct CommentaryView: View {
    // This is a placeholder for a future value
    @EnvironmentObject private var rtcManager: RTCManager
    
    var body: some View {
        if rtcManager.mediaPlayPresentInChannel {
            CommentationView()
        } else {
            RTMPSetupView()
        }
    }
}

struct CommentaryView_Previews: PreviewProvider {
    static var previews: some View {
        CommentaryView()
    }
}
