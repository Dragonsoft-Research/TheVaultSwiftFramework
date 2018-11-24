//
//  ExportWalletAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 12/6/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class ExportWalletAPI: NSObject, JSONCodable {
    public let account: String
    public let password: String
    
    public init(account: String, password: String) {
        self.account  = account
        self.password = password
    }
}
