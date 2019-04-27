//
//  SignalingApiProvider.swift
//  Runner
//
//  Created by Sudharshan on 3/29/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class SignalingApiProvider: NSObject {
    var authToken: String
    
    public override init() {
        super.init()
    }
    
    public convenience init(authToken: String) {
        self.init()
        self.authToken = authToken
    }
    
    public func getUserDevices(userId: String) -> [String] {
        let url: URL = URL(string: "http://staging.beepvoice.app/user/\(userId)/devices")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>
        
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            print(response)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: dataVal, options: []) as? NSDictionary {
                    print("Synchronous\(jsonResult)")
                    // Need code to convert this to an array of strings
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func getConversationUsers(conversationId: String) -> [String] {
        let url: URL = URL(string: "http://staging.beepvoice.app/user/conversation/\(conversationId)/member")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>
        
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            print(response)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: dataVal, options: []) as? NSDictionary {
                    print("Synchronous\(jsonResult)")
                    // Need code to convert this to an array of strings
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func postDataToUser(userId: String, deviceId: String) {
        let url: URL = URL(string: "http://staging.beepvoice.app/user/\(userId)/device/\(deviceId)")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>
        
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            print(response)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: dataVal, options: []) as? NSDictionary {
                    print("Synchronous\(jsonResult)")
                    // Need code to convert this to an array of strings
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
