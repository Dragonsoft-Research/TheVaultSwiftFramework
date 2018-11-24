//
//  TokenInfoAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 31/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class TokenInfoAPI: NSObject, JSONCodable {
    public let symbol: String
    
    public init(symbol: String) {
        self.symbol = symbol
    }
}
