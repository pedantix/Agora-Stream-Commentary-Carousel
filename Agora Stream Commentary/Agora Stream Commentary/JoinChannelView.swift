//
//  JoinChannelView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import SwiftUI

struct JoinChannelView: View {
    @EnvironmentObject var rtcManager: RTCManager
    @State private var isJoinable = false
        
    var body: some View {
        VStack{
            Text("Agora Stream Commentary Demo")
                .font(.title3)
                .padding()
            TextField("Channel Name", text: $rtcManager.channelId)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 350)
                .padding()
            NavigationLink(destination:
                            CommentaryView()
                .onDisappear {
                    rtcManager.leaveChannel()
                }
                .onAppear {
                    rtcManager.joinChannel()
                }
            ) {
                Text("Join Channel")
            }.disabled(rtcManager.channelId.isBlank)
        }
    }
}

struct JoinChannelView_Previews: PreviewProvider {
    static var previews: some View {
        JoinChannelView()
    }
}
