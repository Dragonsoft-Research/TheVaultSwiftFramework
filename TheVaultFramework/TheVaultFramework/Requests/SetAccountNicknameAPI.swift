//
//  File.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 7/6/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class SetAccountNicknameAPI: NSObject, JSONCodable {
    public let account:  String
    public let nickname: String
    
    public init(account: String, nickname: String) {
        self.account  = account
        self.nickname = nickname
    }
}
