//
//  LoginAPI.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 06/12/2017.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

class LoginAPIOld {
    
    struct Login : Codable, JSONCodable {
        let username : String
        let password : String
        
        init(userName:String, password:String) {
            self.apikey   = Globals.APIKEY
            self.username = userName
            self.password = password
        }
    }
    
    
    var login : Login
    
    init(userName:String, password:String) {
        self.login = Login(userName: userName, password: password)
    }
    
    func toDictionary() -> Dictionary<String, Any>? {
        if let json = self.login.toDictionary() {
            return json;
        }
        return nil
    }
    
    func getJsonString() -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(login)
            print("LoginAPI: \(String(data: encodedData, encoding: .utf8)!)")
            return encodedData
        } catch let error {
            print("LoginAPI: \(error)")
        }
        return nil
    }
    
    
    func fromJson(jsonString:String?) -> Bool {
        var jsonData: Data?
        var decodedLogin: Login?
        
        if let json = jsonString {
            jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            if let data = jsonData {
                decodedLogin = try? JSONDecoder().decode(Login.self, from: data)
                
                //Print Person Struct
                if decodedLogin != nil {
                    login = decodedLogin!
                    return true
                }
            }
        }
        return false
    }
}
