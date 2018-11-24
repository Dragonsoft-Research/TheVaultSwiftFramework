//
//  AddressAPI.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 30/10/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class AddressAPI : NSObject, JSONCodable {
    public let account : String
    
    public init(account: String) {
        self.account = account
    }
}

