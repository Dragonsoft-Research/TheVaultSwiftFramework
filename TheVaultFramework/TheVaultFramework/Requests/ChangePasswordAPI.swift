//
//  ChangePasswordAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 11/6/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class ChangePasswordAPI: NSObject, JSONCodable {
    public let password: String
    
    public init(password: String) {
        self.password = password
    }
}
