//
//  registerDeviceAPI.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 19/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import UIKit

@objcMembers public class RegisterDeviceAPI: NSObject, JSONCodable {
    public let userid      : String
    public let pushToken   : String
    public let platform    : String
    public let device      : String
    public let os          : String
        
    init(userName:String, pushToken:String) {
        self.userid = userName
        self.pushToken = pushToken
        let device = UIDevice()
        self.platform = "IOS"
        self.device = String(describing: device.model)
        self.os = String(describing: device.systemVersion)
    }
}
    
