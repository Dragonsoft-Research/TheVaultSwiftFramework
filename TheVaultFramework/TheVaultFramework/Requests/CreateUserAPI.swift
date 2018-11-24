//
//  CreateUser.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 21/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class CreateUserAPI : NSObject, JSONCodable {
    public let username: String
    public let password: String
    public let fullname: String
    public let secureWord: String
    public let question: String
    public let answer: String
    
    public init(username: String, password: String, fullname: String, secureWord: String, question: String, answer: String) {
        self.username   = username
        self.password   = password
        self.fullname   = fullname
        self.secureWord = secureWord
        self.question   = question
        self.answer     = answer
    }
}
