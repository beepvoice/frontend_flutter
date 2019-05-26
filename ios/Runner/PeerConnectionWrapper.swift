//
//  RTCWrapper.swift
//  Runner
//
//  Created by Sudharshan on 3/26/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import WebRTC

public enum RTCWrapperState {
    case disconnected
    case connected
    case connecting
}

class PeerConnectionWrapper: NSObject{
    // State
    var state: RTCWrapperState = .disconnected
    var remoteUserId: String?
    var remoteDeviceId: String?
    
    // WebRTC initialization
    var connectionFactory: RTCPeerConnectionFactory?
    var signalingApiProvider: SignalingApiProvider?
    var peerConnection: RTCPeerConnection?
    var remoteIceCandidates: [RTCIceCandidate] = []
    
    // Constant configuration defaults
    let iceServers: [RTCIceServer] = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
    let connectionConstraint = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": "true"])
    let channelConstraint = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio" : "true"], optionalConstraints: nil)
    
    // Streams
    var localMediaStream: RTCMediaStream!
    var localAudioTrack: RTCAudioTrack!
    var remoteAudioTrack: RTCAudioTrack!
    
    public override init() {
        super.init()
    }
    
    public convenience init(connectionFactory: RTCPeerConnectionFactory, signalingApiProvider: SignalingApiProvider, remoteUserId: String, remoteDeviceId: String) {
        self.init()
        self.connectionFactory = connectionFactory
        self.signalingApiProvider = signalingApiProvider
        self.remoteUserId = remoteUserId
        self.remoteDeviceId = remoteDeviceId
        
        initialisePeerConnection()
    }
    
    public func connect() {
        if let peerConnection = self.peerConnection {
            self.state = .connecting
            let localStream = self.localStream()
            peerConnection.add(localStream)
        }
    }
    
    public func disconnect() {
        if let peerConnection = self.peerConnection {
            peerConnection.close()
            if let stream = peerConnection.localStreams.first {
                peerConnection.remove(stream)
            }
            self.state = .disconnected
        }
    }
    
    public func createOffer(userId: String, deviceId: String) {
        if let peerConnection = self.peerConnection {
            
            peerConnection.offer(for: self.channelConstraint, completionHandler: { [weak self]  (sdp, error) in
                // Exit if this object doesn't exist anymore cause it is a weak link
                guard self != nil else { return }
                
                if let error = error {
                    print(error)
                } else {
                    // Use the sdp generated
                    self?.handleLocalSdpSet(sdp: sdp)
                    self?.signalingApiProvider?.postDataToUser(userId: userId, deviceId: deviceId, data: sdp!.sdp, event: "offer")
                }
            })
        }
    }
    
    public func handleAnswer(remoteSdp: String) {
        if let peerConnection = self.peerConnection {
            let sessionDescription = RTCSessionDescription.init(type: .answer, sdp: remoteSdp)
            
            peerConnection.setRemoteDescription(sessionDescription, completionHandler: { [weak self] (error) in
                // Exit if this object doesn't exist anymore cause it is a weak link
                guard let this = self else { return }
                
                if let error = error {
                    // Throw an error
                    print(error)
                } else {
                    // handle the remote sdp
                    this.handleRemoteDescriptionSet()
                    this.state = .connected
                }
            })
        }
    }
    
    public func createAnswerForOffer(userId: String, deviceId: String, remoteSdp: String) {
        if let peerConnection = self.peerConnection {
            let sessionDescription = RTCSessionDescription.init(type: .offer, sdp: remoteSdp)
            peerConnection.setRemoteDescription(sessionDescription, completionHandler: { [weak self] (error) in
                // Exit if this object doesn't exist anymore cause it is a weak link
                guard let this = self else { return }
                
                if let error = error {
                    // Throw an error
                    print(error)
                } else {
                    // handle the remote sdp
                    this.handleRemoteDescriptionSet()
                    
                    // create answer
                    peerConnection.answer(for: this.channelConstraint, completionHandler:
                        { (sdp, error) in
                            if let error = error {
                                // Throw an error
                                print(error)
                            } else {
                                // handle generated local sdp
                                self?.handleLocalSdpSet(sdp: sdp)
                                self?.signalingApiProvider?.postDataToUser(userId: userId, deviceId: deviceId, data: sdp!.sdp, event: "answer")
                                this.state = .connected
                            }
                    })
                }
            })
        }
    }
    
    public func addIceCandidate(iceCandidate: RTCIceCandidate) {
        // Set ice candidate after setting remote description
        if self.peerConnection?.remoteDescription != nil {
            self.peerConnection?.add(iceCandidate)
        } else {
            self.remoteIceCandidates.append(iceCandidate)
        }
    }
}

private extension PeerConnectionWrapper {
    /*
    func initialisePeerConnectionFactory () {
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }*/
    
    func initialisePeerConnection () {
        let configuration = RTCConfiguration()
        configuration.iceServers = self.iceServers;
        self.peerConnection = self.connectionFactory?.peerConnection(with: configuration, constraints: self.connectionConstraint, delegate: self)
    }
    
    func handleLocalSdpSet(sdp: RTCSessionDescription?) {
        guard let sdp = sdp else{
            return
        }
        
        self.peerConnection?.setLocalDescription(sdp, completionHandler: {[weak self] (error) in
            guard let _ = self, let error = error else { return }
            print(error)
        })
    }
    
    func handleRemoteDescriptionSet() {
        for iceCandidate in self.remoteIceCandidates {
            self.peerConnection?.add(iceCandidate)
        }
        self.remoteIceCandidates = []
    }
    
    func localStream() -> RTCMediaStream {
        let factory = self.connectionFactory!
        let localStream = factory.mediaStream(withStreamId: "RTCmS")
        
        let audioTrack = factory.audioTrack(withTrackId: "RTCaS0")
        localStream.addAudioTrack(audioTrack)
        
        return localStream
    }
}

extension PeerConnectionWrapper: RTCPeerConnectionDelegate {
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {

    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {

    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("adding new stream from remote")
        self.remoteAudioTrack = stream.audioTracks[0]
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {

    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {

    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {

    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        let candidateString = "\(candidate.sdp)::\(candidate.sdpMLineIndex)::\(candidate.sdpMid ?? "")"
        self.signalingApiProvider?.postDataToUser(userId: remoteUserId!, deviceId: remoteDeviceId!, data: candidateString, event: "ice-candidate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {

    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
    
    }
}
