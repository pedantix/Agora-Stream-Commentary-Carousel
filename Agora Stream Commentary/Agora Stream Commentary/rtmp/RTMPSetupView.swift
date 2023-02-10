//
//  RTMPSetupView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/8/23.
//

import SwiftUI

struct RTMPSetupView: View {
    @EnvironmentObject var rtmpMediaPlayer: RTMPMediaPlayer
    
    var body: some View {
        VStack {
            Text("No feed to watch, please add a feed")
                .font(.title3)
                .padding()
            
            HStack {
                TextField("rtmp://", text: $rtmpMediaPlayer.rtmpString)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 350)
                    .padding()
                
                Button {
                    rtmpMediaPlayer.validate()
                }
                label: {
                    Text("Validate")
                }            
                .disabled(rtmpMediaPlayer.isValidating)
                .buttonStyle(.bordered)
            }
            if rtmpMediaPlayer.isInvalidEntry {
                Text("Entry invalid")
                    .foregroundColor(.red)
                    .padding()
            }
            Button  {
                logger.info("start the show")
            }
            label: {
                Text("Start Feed")
            }.disabled(!rtmpMediaPlayer.isValid)
                .buttonStyle(.borderedProminent)
            
        }
    }
}

struct RTMPSetupView_Previews: PreviewProvider {
    static var previews: some View {
        RTMPSetupView()
    }
}
