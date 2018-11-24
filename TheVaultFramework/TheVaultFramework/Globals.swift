//
//  Globals.swift
//  TheVault
//
//  Created by Paul Stinchcombe on 31/10/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class Globals: NSObject {
    public static var SERVER = "https://api.thevault.cc/v1.0.0"
    
    public static var EXCHANGE = {
        return "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD"
    }()
    
    public static var APIKEY = ""
    public static var Authenticated = false;
    public static var Token = ""
    public static var Accounts : [AccountsData.account]?
    public static var Favorites : [FavoritesData.favorite]?
    public static var CurrentSymbol = "ETH"
    public static var CurrentAccount = 0
    public static var CurrencyAmount : Double = 0.00
    public static var Transactions = [TransactionData.Transaction]()
    public static var PushToken = ""
    public static var DeviceRegistered = false
    public static var ExchangeRate : Double = 0.0
    
    
    public static func findInInternalAccounts( _ address: String) -> String? {
        var name: String? = nil
        if let accounts = Accounts {
            for account in accounts {
                if address.lowercased() == account.address.lowercased() {
                    name = account.nickname
                    break
                }
            }
        }
        
        if name == nil {
            // Loop through favorites
            if let accounts = Favorites {
                for account in accounts {
                    if address.lowercased() == account.address.lowercased() {
                        name = account.nickname
                        break
                    }
                }
            }
        }
        
        return name
    }


}



