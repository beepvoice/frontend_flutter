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
    // Globals
    var connectionFactory: RTCPeerConnectionFactory?
    var peerConnection: RTCPeerConnection?
    
    // Constant configs
    let defaultOfferConstraints = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "false"], optionalConstraints: nil)
    let defaultConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": "true"])
    
    init() {
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
    
    func initialisePeerConnection() {
        let configuration = RTCConfiguration()
        configuration.iceServers = self.iceServers
        self.peerConnection = self.connectionFactory?.peerConnection(with: configuration, constraints: self.defaultConnectionConstraint, delegate: self)
    }
    
    func startConnection() {
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
    
    func localStream() -> RTCMediaStream {
        if let factory = self.connectionFactory {
            let localStream = factory.mediaStream(withStreamId: "RTCmS")
            
            if !AVCaptureState.isAudioDisabled {
                let audioTrack = factory.audioTrack(withTrackId: "RTCaS0")
                localStream.addAudioTrack(audioTrack)
            } else {
                // Show error for audio perms disabled
                let error = NSError.init(domain: ErrorDomain.audioPermissionDenied, code: 0, userInfo: nil)
                self.delegate?.rtcClient(client: self, didReceiveError: error)
            }
            
            return localStream
        }
    }
    
    func makeOffer() {
        guard let peerConnection = self.peerConnection else {
            return
        }
        
        peerConnection.offer(for: self.defaultOffetConstraints, completionHandler: { (sdp, error) in
            if let error = error {
                self.delegate?.rtcClient(client: self, didReceiveError: error as NSError)
            } else {
                self.handleSdpGenerated(sdpDescription: sdp)
            }
        })
    }
    
    func handleSdpGenerated(sdpDescription: RTCSessionDescription) {
        guard let sdpDescription = sdpDescription else {
            return
        }
    }
}
