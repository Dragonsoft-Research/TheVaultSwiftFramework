//
//  UserDetailsAPI.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 1/2/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class GetUserDetailsAPI: NSObject {
    
    @objcMembers public class GetUserDetails : NSObject, JSONCodable {
        public let apikey   : String
        public let token    : String
        
        public override init() {
            self.apikey   = Globals.APIKEY
            self.token    = Globals.Token
        }
    }
    
    
    public var getUserDeatils : GetUserDetails
    
    public override init() {
        self.getUserDeatils = GetUserDetails()
    }
    
}
