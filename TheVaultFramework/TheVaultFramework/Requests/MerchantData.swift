//
//  SendMerchantTransactionAPI.swift
//  TheVaultFramework
//
//  Created by Amy on 30/10/2018.
//  Copyright © 2018 World Quest International. All rights reserved.
//

import Foundation

@objcMembers public class MerchantData : NSObject, JSONCodable {
    public var apikey          :String
    public var name            :String
    public var symbol          :String
    public var receiveAddress  :String
    public var orderid         :String
    public var amount          :String
    public var currency        :String
    public var baseCryptoAmount:String
    
    public init(apikey:String, name:String, symbol:String, receiveAddress:String, orderid:String, amount:String, currency:String, baseCryptoAmount:String) {
        self.apikey             = apikey
        self.name               = name
        self.symbol             = symbol
        self.receiveAddress     = receiveAddress
        self.orderid            = orderid
        self.amount             = amount
        self.currency           = currency
        self.baseCryptoAmount   = baseCryptoAmount
    }
}
