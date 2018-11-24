//
//  UserData.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 1/2/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class TInfo: NSObject, Codable {
    public let symbol       :String
    public let decimals     :Int
    public let name         :String
    public let image        :String
    public let balance      :String
}

@objcMembers public class User: NSObject, Codable {
    public var userid           :String
    public var fullName         :String
    public var address          :String
    public var receiveAddress   :String
    public var type             :String
    public var nickname         :String
    public var lastUpdated      :String
    public var balance          :String
    public var image            :String
    public var tokens           :[TInfo]?
    
    
    private enum CodingKeys : String, CodingKey {
        case userid, fullName = "full_name", address, receiveAddress, type, nickname, lastUpdated, balance, image, tokens
    }
    
    override public init() {
        self.userid = ""
        self.fullName = ""
        self.address = ""
        self.receiveAddress = ""
        self.type = ""
        self.nickname = ""
        self.lastUpdated = ""
        self.balance = ""
        self.image = ""
    }
}


@objcMembers public class UserData: NSObject, Codable {
    
    public var success  : Bool
    public var users : [User]
    
    override public init() {
        self.success = false;
        self.users = [User]()
    }
    
    public init(success:Bool, users:[User]) {
        self.success  = success
        self.users = users
    }
    
    public static func get() -> UserData? {
        if let me = DataManager.load(with: UserData.self) {
            return UserData(success: me.success, users: me.users)
        }
        return nil
    }
    
    public func save() {
        DataManager.save(self)
    }
    
}
