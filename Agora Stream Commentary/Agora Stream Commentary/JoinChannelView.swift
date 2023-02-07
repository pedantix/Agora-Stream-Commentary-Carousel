//
//  JoinChannelView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import SwiftUI

struct JoinChannelView: View {
    @State private var channelName = ""
    @State private var isJoinable = false
    
    
    var body: some View {
        VStack{
            Text("Agora Stream Commentary Demo")
                .font(.title3)
                .padding()
            TextField("Channel Name", text: $channelName)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 350)
                .padding()
                .onChange(of: channelName) { newValue in
                    isJoinable = !newValue.isBlank
                }
            NavigationLink(destination: CommentaryView()) {
                Text("Join Channel")
            }.disabled(!isJoinable)
        }
    }
}

struct JoinChannelView_Previews: PreviewProvider {
    static var previews: some View {
        JoinChannelView()
    }
}
