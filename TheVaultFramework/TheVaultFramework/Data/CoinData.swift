//
//  CoinData.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 21/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class CoinItem : NSObject, Codable {
    public let symbol: String
    public let name: String
    public let image: String
    public let type : String
    public let subtype : String?
}

@objcMembers public class CoinData : NSObject, Codable {
    public let coins: [CoinItem]
}
