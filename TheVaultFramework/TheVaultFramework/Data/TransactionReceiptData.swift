//
//  TransactionReceiptData.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 14/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

// {"success":true,"receipt":{"transactionHash":"0x58d5124395aff7376dfa4f9e82b5b486821781aa62768b391240e15a1df7e9f3","transactionIndex":0,"blockHash":"0x58bf6c2763ebdacd527033a8e1c1341b704b3deac2b5871008d132df439d711a","blockNumber":4,"gasUsed":21000,"cumulativeGasUsed":21000,"contractAddress":null,"logs":[]}}

@objcMembers public class TransactionReceiptData: NSObject, Codable {
    
    @objcMembers public class Receipt: NSObject, Codable {
        public let transactionHash     :String
        public let transactionIndex    :UInt
        public let blockHash           :String
        public let blockNumber         :UInt
        public let gasUsed             :UInt
        public let cumulativeGasUsed   :UInt
        public let contractAddress     :String?
    }
    
    public let success          :Bool
    public let receipt          :Receipt
}
