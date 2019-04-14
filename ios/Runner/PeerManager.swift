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
    var eventSource: EventSource = EventSource(url: "https://staging.beepvoice.app/signal")
    
    // List of users
    var peerList: [String: PeerConnectionWrapper] = [:]
    
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
    func initialisePeerConnectionFactory() {
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
    
    func initialiseEventSource() {
        eventSource.addEventListener("offer") { (id, event, data) in
            // Handling offers, if in list accept
        }
        
        eventSource.addEventListener("answer") { (id, event, data) in
            // Handling answers, if in list accept
        }
        
        eventSource.addEventListener("ice-candidate") { (id, event, data) in
            // Handling ice candidates, if in list accept
        }
    }
}
