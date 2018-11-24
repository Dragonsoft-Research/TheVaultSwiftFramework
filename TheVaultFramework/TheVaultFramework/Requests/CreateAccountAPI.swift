//
//  CreateAccountAPI.swift
//  EthWallet
//
//  Created by Swastik Soni on 23/05/2018.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class CreateAccountAPI : NSObject, JSONCodable {
    public let nickname :String
    public let wpw      :String
    
    public init(nickname: String, wpw: String) {
        self.nickname = nickname
        self.wpw      = wpw
    }
}
