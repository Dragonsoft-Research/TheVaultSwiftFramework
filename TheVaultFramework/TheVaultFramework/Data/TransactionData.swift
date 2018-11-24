//
//  Transaction.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 06/12/2017.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//


import Foundation

@objcMembers public class TransactionData: NSObject, Codable {
    @objcMembers public class Transaction: NSObject, Codable {
        public let txhash           :String
        public let nonce            :UInt
        public let blockHash        :String
        public let blockNumber      :UInt
        public let transactionIndex :UInt
        public let from             :String
        public let to               :String
        public let value            :String
        public let time             :Double
        public let gas              :UInt
        public let gasPrice         :String
        public let input            :String?
        public let memo             :String?
        
        enum CodingKeys: String, CodingKey {
            case txhash = "hash"
            case nonce
            case blockHash
            case blockNumber
            case transactionIndex
            case from
            case to
            case value
            case time
            case gas
            case gasPrice
            case input
            case memo
        }
        
        public init(txn: Transaction) {
            self.txhash             = txn.txhash
            self.nonce              = txn.nonce
            self.blockHash          = txn.blockHash
            self.blockNumber        = txn.blockNumber
            self.transactionIndex   = txn.transactionIndex
            self.from               = txn.from
            self.to                 = txn.to
            self.value              = txn.value
            self.time               = txn.time
            self.gas                = txn.gas
            self.gasPrice           = txn.gasPrice
            self.input              = txn.input
            self.memo               = txn.memo
        }
        
        public var timestampAsUTCDate : Date {
            get {
                return Date(timeIntervalSince1970: time)
            }
        }
        
        public var localDateTimeString : String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
            let utcDateTime = String(describing: timestampAsUTCDate)
            let dt = dateFormatter.date(from: utcDateTime)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            return dateFormatter.string(from: dt!)
        }
    }
    
    public let success         :Bool
    public let transactions    :[Transaction]

    
    override public init() {
        self.success        = false;
        self.transactions   = [Transaction]()
    }
    
    public init(success:Bool, transactions:[Transaction]) {
        self.success        = success
        self.transactions   = transactions
    }

}
