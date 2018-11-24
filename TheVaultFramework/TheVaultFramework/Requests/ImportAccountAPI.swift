//
//  ImportAccountAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 11/6/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class ImportAccountAPI: NSObject, JSONCodable {
    public let account:     String
    public let privateKey:  String
    public let nickname:    String
    
    public init(account: String, privateKey: String, nickname: String) {
        self.account    = account
        self.privateKey = privateKey
        self.nickname   = nickname
    }
}
