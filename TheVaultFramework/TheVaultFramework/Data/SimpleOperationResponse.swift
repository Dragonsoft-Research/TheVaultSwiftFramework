//
//  SimpleOperationResponse.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 26/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class SimpleOperationResponse: NSObject, Codable {
    
    public let success :Bool
    public let error   :String?
    
    init(success: Bool, error: String?) {
        self.success = success
        self.error = error
    }
}
