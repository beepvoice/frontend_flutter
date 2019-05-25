//
//  SignalingApiProvider.swift
//  Runner
//
//  Created by Sudharshan on 3/29/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import WebRTC

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
        let url: URL = URL(string: "http://localhost/signal/user/\(userId)/devices")!
        var deviceList: [String] = []
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken ?? "0")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        var response: URLResponse?
        
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: dataVal, options: []) as? [String] {
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
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func getConversationUsers(conversationId: String) -> [String]? {
        let url: URL = URL(string: "http://localhost/core/user/conversation/\(conversationId)/member")!
        var userList: [String] = []
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken ?? "0")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        var response: URLResponse?
        
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: dataVal, options: []) as? [Any] {
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
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // CHECK FOR WHEN DEVICE IS UNAVAILABLE
    public func postDataToUser(userId: String, deviceId: String, data: String, event: String) {
        let url: URL = URL(string: "http://localhost/signal/user/\(userId)/device/\(deviceId)")!
        
        // prepare json data
        let json: [String: Any] = ["event": event, "data": data]
        print(json)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken ?? "0")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        var response: URLResponse?
        
        do {
            let _ = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
