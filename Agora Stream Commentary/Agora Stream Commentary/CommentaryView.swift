//
//  CommentaryView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/7/23.
//

import SwiftUI

struct CommentaryView: View {
    // This is a placeholder for a future value
    @State private var isRTMPFeedActive = false
    
    var body: some View {
        if isRTMPFeedActive {
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
