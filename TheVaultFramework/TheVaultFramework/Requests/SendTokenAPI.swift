//
//  SendTokenAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 30/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class SendTokenAPI: NSObject, JSONCodable {
    public let account :String
    public let to      :String
    public let value   :String
    public let txFee   :String
    public let symbol  :String
    public let memo    :String?
    public let merchant:MerchantData?

    init(to:String, value:String, symbol:String, txFee:String = "21000", memo:String?, merchant:MerchantData?) {
        self.account = Globals.Accounts![Globals.CurrentAccount].address
        self.to      = to
        self.value   = value
        self.txFee   = txFee
        self.symbol  = symbol
        self.memo    = memo
        self.merchant = merchant
    }
}
