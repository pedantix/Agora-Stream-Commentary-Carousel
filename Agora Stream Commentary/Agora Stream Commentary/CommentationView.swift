//
//  CommentationView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/8/23.
//

import SwiftUI

struct CommentationView: View {
    @Environment(\.isPreview) var isPreview
    @EnvironmentObject var rtcManager: RTCManager
    
    
    var body: some View {
        GeometryReader { proxy in
            let commentatorDimension = min(proxy.size.height, proxy.size.width) * 0.3
            ZStack(alignment: .topTrailing) {
                streamView
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background(isPreview ? .yellow : .black)
                
            commentatorView
                    .frame(width: commentatorDimension, height: commentatorDimension)
                    .background(isPreview ? .blue : .gray)
                    .padding()
                
                
            }
        }
    }
    
    @ViewBuilder
    private var commentatorView: some View {
        if isPreview {
            Text("Commentor view")
        } else {
            RTCView(uid: rtcManager.myUid)
        }
    }
    
    @ViewBuilder
    private var streamView: some View {
        if isPreview {
            Text("Stream View")
        } else {
            RTCView(uid: RTCManager.broadcastUid)
        }
    }
}

struct CommentationView_Previews: PreviewProvider {
    static var previews: some View {
        CommentationView()
    }
}

private struct IsPreviewKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}
