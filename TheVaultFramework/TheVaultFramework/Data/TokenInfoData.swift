//
//  TokenInfoData.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 31/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class TokenInfo : NSObject, Codable {
    public let symbol          :String
    public let name            :String
    public let decimals        :String
    public let contractAddress :String
}

@objcMembers public class TokenInfoData : NSObject, Codable {
    let tokenInfo  :TokenInfo
}
