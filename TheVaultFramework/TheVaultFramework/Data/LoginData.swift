//
//  Login.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 7/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//


@objcMembers public class LoginData: NSObject, Codable {
    public var success :Bool
    public var token   :String
    
    override public init() {
        success = false
        token   = ""
    }
    
    public init(success:Bool, token:String) {
        self.success = success
        self.token   = token
    }
}
