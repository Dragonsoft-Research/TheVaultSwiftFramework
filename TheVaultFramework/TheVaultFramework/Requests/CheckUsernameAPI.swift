//
//  checkUsername.swift
//  EthWallet
//
//  Created by Swastik Soni on 31/07/2018.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class CheckUsernameAPI: NSObject, JSONCodable {
    public let username: String
    
    public init(username: String) {
        self.username = username
    }
}
