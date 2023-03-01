//
//  RTCView.swift
//  Agora Stream Commentary
//
//  Created by shaun on 3/1/23.
//

import Foundation
import SwiftUI

struct RTCView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    @EnvironmentObject private var rtcManager: RTCManager
    let uid: UInt

    func makeUIViewController(context: Context) -> UIViewController {        
        let vc = RTCViewController()
        vc.uid = uid
        vc.rtcManager = rtcManager
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // noop
        logger.info("Update controller \(uiViewController) \(uid)")
    }
}

private class RTCViewController: UIViewController {
    var rtcManager: RTCManager? = nil
    var uid: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rtcManager?.setupCanvasFor(view, uid)
    }
}
