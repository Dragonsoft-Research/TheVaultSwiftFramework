//
//  SendMerchantTransactionAPI.swift
//  TheVaultFramework
//
//  Created by Amy on 30/10/2018.
//  Copyright © 2018 World Quest International. All rights reserved.
//

import Foundation

@objcMembers public class MerchantData : NSObject, JSONCodable {
   @objcMembers public class Merchant: NSObject, Codable {
    public let apikey          :String
    public let name            :String
    public let symbol          :String
    public let receiveAddress  :String
    public let orderid         :String
    public let amount          :String
    public let currency        :String
    
    public init(vm: Merchant) { //(apiKey:String, name:String, symbol:String, receiveAddress:String, orderid:String, amount:String, currency:String) {
        self.apikey         = vm.apikey
        self.name           = vm.name
        self.symbol         = vm.symbol
        self.receiveAddress = vm.receiveAddress
        self.orderid        = vm.orderid
        self.amount         = vm.amount
        self.currency       = vm.currency
    }
  }
}
