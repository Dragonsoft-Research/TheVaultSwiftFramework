//
//  TokenTransactionData.swift
//  EthWallet
//
//  Created by Swastik Soni on 28/06/2018.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class TokenTransactionItem: NSObject, Decodable {
    public let txhash           :String
    public let blockNumber      :Int
    public let blockHash        :String?
    public let transactionIndex :Int
    public let confirmations    :Int
    public let value            :Double
    public let from             :String
    public let to               :String
    public let timestamp        :Double
    public let memo             :String?
    
    enum CodingKeys: String, CodingKey {
        case txhash = "hash"
        case blockNumber
        case blockHash
        case transactionIndex
        case confirmations
        case value
        case from
        case to
        case timestamp
        case memo
        
    }
    
    public var timestampAsUTCDate : Date {
        get {
            return Date(timeIntervalSince1970: timestamp)
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

@objcMembers public class TokenTransactionData: NSObject, Decodable {
    public let success         :Bool
    public let transactions    :[TokenTransactionItem]
    
    override public init() {
        self.success        = false;
        self.transactions   = [TokenTransactionItem]()
    }
    
    public init(success:Bool, transactions:[TokenTransactionItem]) {
        self.success        = success
        self.transactions   = transactions
    }
}
