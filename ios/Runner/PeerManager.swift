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
    var signalingApiProvider: SignalingApiProvider?
    var eventSource: EventSource?
    
    // List of users
    var peerList: [String: PeerConnectionWrapper] = [:]
    var whitePeerList: [String] = []
    var activeConversation: String?
    
    public override init() {
        super.init()
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
    
    // MUST CALL THIS BEFORE SIGNALLING WORKS
    public func initializeToken(authToken: String) {
        self.signalingApiProvider = SignalingApiProvider(authToken: authToken)
        self.eventSource = EventSource(url: "http://localhost/signal/subscribe?token=\(authToken)")
    }
    
    public func join(conversationId: String) {
        let userOpList = signalingApiProvider?.getConversationUsers(conversationId: conversationId)
        activeConversation = conversationId
        
        guard let userList = userOpList else {
            // Error incorrect conversation ID
            return
        }
        
        for user in userList {
            whitePeerList.append(user)
            
            let deviceOpList = signalingApiProvider?.getUserDevices(userId: user)
            
            guard let deviceList = deviceOpList else {
                // Error incorrect user ID
                return
            }
            
            for device in deviceList {
                let connection: PeerConnectionWrapper = PeerConnectionWrapper(connectionFactory: self.connectionFactory!, signalingApiProvider: self.signalingApiProvider!, remoteUserId: user, remoteDeviceId: device)
                self.peerList["\(user)-\(device)"] = connection
                connection.createOffer(userId: user, deviceId: device)
            }
        }
    }
    
    public func exit() {
        for (_, connection) in peerList {
            connection.disconnect()
        }
        
        whitePeerList = []
        peerList = [:]
        activeConversation = nil
    }
    
    public func get() -> String? {
        return activeConversation
    }
}

private extension PeerManager {
    func initialiseEventSource() {
        eventSource?.addEventListener("offer") { (id, event, data) in
            
            guard let id = id, let data = data else {
                // Incorrect packet type error
                return
            }
            
            // Handling offers, if in list accept
            if self.whitePeerList.contains(id) {
                // Split id into user and device
                let idArr = id.components(separatedBy: "-")
                
                // Check id format
                if idArr.count != 2 {
                    // Incorrect id format error
                    return
                }
                
                let connection: PeerConnectionWrapper = PeerConnectionWrapper(connectionFactory: self.connectionFactory!, signalingApiProvider: self.signalingApiProvider!, remoteUserId: idArr[0], remoteDeviceId: idArr[1])
                self.peerList[id] = connection
                
                
                connection.createAnswerForOffer(userId: idArr[0], deviceId: idArr[1], remoteSdp: data)
                connection.connect()
            }
        }
        
        eventSource?.addEventListener("answer") { (id, event, data) in
            
            guard let id = id, let data = data else {
                // Incorrect packet type error
                return
            }
            
            // Handling answers, if in list accept
            if self.whitePeerList.contains(id) {
                let connection: PeerConnectionWrapper = self.peerList[id]!
                connection.handleAnswer(remoteSdp: data)
                connection.connect()
            }
        }
        
        eventSource?.addEventListener("ice-candidate") { (id, event, data) in
            
            guard let id = id, let data = data else {
                // Incorrect packet type error
                return
            }
            
            // Handling ice candidates, if in list accept
            if self.whitePeerList.contains(id) {
                let connection: PeerConnectionWrapper = self.peerList[id]!
                
                let dataArr = data.components(separatedBy: "-")
                
                // Check dataArr size of 3
                if dataArr.count != 3 {
                    // Incorrect data format error
                    return
                }
                
                // Convert sdpMLineIndex to Int32
                guard let sdpMLineIndex = Int32(dataArr[1]) else {
                    // Invalid sdpMLineIndex error
                    return
                }
                
                let iceCandidate = RTCIceCandidate(sdp: dataArr[0], sdpMLineIndex: sdpMLineIndex, sdpMid: dataArr[1])
                connection.addIceCandidate(iceCandidate: iceCandidate)
            }
        }
    }
}
