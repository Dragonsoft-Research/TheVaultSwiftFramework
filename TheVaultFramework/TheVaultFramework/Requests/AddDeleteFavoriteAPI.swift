//
//  AddDeleteFavoriteAPI.swift
//  TheVault
//
//  Created by Paul Stinchcombe on 26/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class AddDeleteFavoriteAPI: NSObject, JSONCodable {
    public let address  : String
    public let nickname : String
    public let currency : String
    
    public init(address: String, nickname: String, currency: String) {
        self.address  = address
        self.nickname = nickname
        self.currency = currency
    }
}
