//
//  Balance.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 30/10/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//



@objcMembers public class BalanceData: NSObject, Codable {
    public var balance : String
    
    override public init() {
        self.balance = ""
    }
    
    public init(balance:String) {
        self.balance = balance
    }
}
    

