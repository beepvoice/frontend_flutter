//
//  RTCWrapper.swift
//  Runner
//
//  Created by Sudharshan on 3/26/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import WebRTC

class RTCWrapper{
    var connectionFactory: RTCPeerConnectionFactory;
    var peerConnection: RTCPeerConnection;
    
    init() {
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
    
    func initialisePeerConnection () {
        let configuration = RTCConfiguration()
        configuration.iceServers = self.iceServers
        self.peerConnection = self.connectionFactory.peerConnection(with: configuration, constraints: self.defaultConnectionConstraint, delegate: self)
    }
    
    func startConnection () {
        guard let peerConnection = self.peerConnection else {
            return
        }
        
        self.state = .connecting
        let localStream = self.localStream()
        peerConnection.add(localStream)
        if let localVideoTrack = localStream.videoTracks.first {
            self.delegate?.rtcClient(client: self, didReceiveLocalVideoTrack: localVideoTrack)
        }
    }
    
    
}
