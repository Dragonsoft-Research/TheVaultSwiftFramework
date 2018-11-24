//
//  RegistrationData.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 19/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class RegistrationData: NSObject, Codable {
    public let success :Bool
    
    override public init() {
        success = false
    }
    
    public init(success:Bool) {
        self.success = success
    }
}
