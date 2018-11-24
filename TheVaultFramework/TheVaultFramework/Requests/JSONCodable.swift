//
//  JSONAble.swift
//  MoneyBag
//
//  Created by Paul Stinchcombe on 07/12/2017.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

protocol JSONCodable: Codable {
    typealias JSON = [String : Any]
    func toDictionary() -> JSON?
    init?(json: JSON)
}

extension JSONCodable {
    
    func toDictionary() -> JSON? {
        // Encode the data
        if let jsonData = try? JSONEncoder().encode(self),
            // Create a dictionary from the data
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? JSON {
            return dict
        }
        return nil
    }
    
    init?(json: JSON) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let object = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch  {
            return nil
        }
    }
    
    func getJsonString() -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(self)
            return encodedData
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

}


