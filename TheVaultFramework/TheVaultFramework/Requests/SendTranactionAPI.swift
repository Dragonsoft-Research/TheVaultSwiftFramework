//
//  SendTranactionAPI.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 14/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class SendTransactionAPI : NSObject, JSONCodable {
    public let account : String
    public let to      : String
    public let value   : String
    public let txFee   : String
    public let memo    : String?
    public let merchant: MerchantData?
    
    init(to:String, value:String, txFee:String = "21000", memo:String?, merchant:MerchantData?) {
        self.account = Globals.Accounts![Globals.CurrentAccount].address
        self.to      = to
        self.value   = value
        self.txFee   = txFee
        self.memo    = memo
        self.merchant = merchant
    }
}
