//
//  FavoritesData.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 7/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

@objcMembers public class FavoritesData: NSObject, Codable {
    @objcMembers public class favorite: NSObject, Codable {
        public var address  :String
        public var nickname :String
        public var currency :String
        
        override public init() {
            address = ""
            nickname = ""
            currency = ""
        }
        
        public init(address:String, nickname:String, currency:String) {
            self.address  = address
            self.nickname = nickname
            self.currency = currency
        }
    }
    
    public var success   : Bool
    public var favorites : [favorite]
    
    override public init() {
        self.success   = false;
        self.favorites = [favorite]()
    }
    
    public init(success:Bool, favorites:[favorite]) {
        self.success   = success
        self.favorites = favorites
    }
}
