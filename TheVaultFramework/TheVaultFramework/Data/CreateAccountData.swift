//
//  CreateAccountData.swift
//  EthWallet
//
//  Created by Swastik Soni on 23/05/2018.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class CreateAccountData: NSObject, Codable {
    @objcMembers public class CAD : NSObject, Codable {
        public var account     :String
        public var nickname    :String
    }
    
    public var success  : Bool
    public var data : CAD?
    
    override public init() {
        self.success = false;
//        self.data = CAD(account: "", nickname: "")
    }
    
    public init(success:Bool, data:CAD?) {
        self.success  = success
        self.data = data
    }
}
