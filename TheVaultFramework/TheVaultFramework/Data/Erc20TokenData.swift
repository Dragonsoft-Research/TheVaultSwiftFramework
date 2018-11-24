//
//  Erc20TokenData.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 22/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class Erc20Token : NSObject, Codable {
    public let address      :String
    public let symbol       :String
    public let type         :String
    public let subtype      :String
    public let name         :String
    public let desc         :String
    public let image        :String
    public let balance      :String
    public let decimal      :String
}

@objcMembers public class Erc20TokenData : NSObject, Codable {
    public let tokens: [Erc20Token]
}
