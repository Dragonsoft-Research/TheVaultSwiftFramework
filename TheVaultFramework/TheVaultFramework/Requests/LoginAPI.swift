//
//  LoginAPI.swift
//  TheVault
//
//  Created by Paul Stinchcombe on 06/12/2017.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class LoginAPI : NSObject, JSONCodable {
    public let username : String
    public let password : String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
