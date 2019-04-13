//
//  PeerManager.swift
//  Runner
//
//  Created by Sudharshan on 3/29/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import WebRTC

class PeerManager: NSObject {
    // WebRTC initialization
    var connectionFactory: RTCPeerConnectionFactory?
    
    // List of users
    var peerList: [PeerConnectionWrapper] = []
    
    public override init() {
        super.init()
        initialisePeerConnectionFactory()
    }
    
    public func join(conversationId: String, usersIds: [String]) {
        
    }
    
    public func exit() {
        
    }
    
    public func get() -> String {
        
    }
}

private extension PeerManager {
    func initialisePeerConnectionFactory () {
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
}
