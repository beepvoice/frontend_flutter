//
//  SignalingApiProvider.swift
//  Runner
//
//  Created by Sudharshan on 3/29/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import WebRTC
import Just

class SignalingApiProvider: NSObject {
    var authToken: String?
    
    public override init() {
        super.init()
    }
    
    public convenience init(authToken: String) {
        self.init()
        self.authToken = authToken
    }
    
    public func getUserDevices(userId: String) -> [String]? {
        var deviceList: [String] = []
        let response = Just.get("http://localhost/signal/user/\(userId)/devices",
            headers: ["Authorization": "Bearer \(authToken ?? "0")"])
        
        if(response.ok) {
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: response.content!, options: []) as? [String] {
                    // convert this to an array of strings
                    for device in jsonResult {
                        deviceList.append(device)
                    }
                    
                    return deviceList
                } else {
                    // Invalid response format
                    return nil
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func getConversationUsers(conversationId: String) -> [String]? {
        var userList: [String] = []
        let response = Just.get("http://localhost/core/user/conversation/\(conversationId)/member",
            headers: ["Authorization": "Bearer \(authToken ?? "0")"])
        
        if (response.ok) {
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: response.content!, options: []) as? [Any] {
                    // Need code to convert this to an array of strings
                    for user in jsonResult {
                        if let userObject = user as? [String: String] {
                            guard let userId = userObject["id"] else {
                                // Invalid response format
                                return nil
                            }
                            
                            userList.append(userId)
                        }
                    }
                    
                    return userList
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // CHECK FOR WHEN DEVICE IS UNAVAILABLE
    public func postDataToUser(userId: String, deviceId: String, data: String, event: String) {
        Just.post("http://localhost/signal/user/\(userId)/device/\(deviceId)",
            json: ["event": event, "data": data],
            headers: ["Authorization": "Bearer \(authToken ?? "0")"])
    }
}
