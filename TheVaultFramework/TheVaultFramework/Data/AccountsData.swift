//
//  AccountsData.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 8/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class AccountsData: NSObject, Codable {
    @objcMembers public class account : NSObject, Codable {
        public var address     :String
        public var nickname    :String
        public var lastUpdated :String
        public var balance     :String
        
        override public init() {
            self.address = ""
            self.nickname = ""
            self.lastUpdated = ""
            self.balance = ""
        }

    }
    
    public var success  : Bool
    public var accounts : [account]
    
    override public init() {
        self.success = false;
        self.accounts = [account]()
    }
    
    public init(success:Bool, accounts:[account]) {
        self.success  = success
        self.accounts = accounts
    }
}


