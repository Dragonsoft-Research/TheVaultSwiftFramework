//
//  GetTokenBalanceAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 12/6/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation


@objcMembers public class GetTokenBalanceAPI: NSObject, JSONCodable {
    public let account: String
    public let symbol: String
    
    public init(account: String, symbol: String) {
        self.account = account
        self.symbol  = symbol
    }
}
