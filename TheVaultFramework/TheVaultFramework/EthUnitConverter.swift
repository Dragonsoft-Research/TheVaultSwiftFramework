//
//  EthUnitConverter.swift
//  TheVault
//
//  Created by Paul Stinchcombe on 15/12/17.
//  Copyright © 2017 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class EthUnitConverter: NSObject {

    public enum OCEthereumUnit: Int {
        case Ether      = 0
        case MilliEther
        case MicroEther
        case Gwei
        case Mwei
        case Kwei
        case Wei
    }
    
    public enum EthereumUnit: String {
        case Ether      = "Ether"
        case MilliEther = "MilliEther"
        case MicroEther = "MicroEther"
        case Gwei       = "Gwei"
        case Mwei       = "Mwei"
        case Kwei       = "Kwei"
        case Wei        = "Wei"
    }
    
    private static let conversions : [EthereumUnit : Double] = [
        .Ether      : 1000000000000000000,
        .MilliEther : 1000000000000000,
        .MicroEther : 1000000000000,
        .Gwei       : 1000000000,
        .Mwei       : 1000000,
        .Kwei       : 1000,
        .Wei        : 1
    ]

    private static let ocConversions : [OCEthereumUnit : Double] = [
        .Ether      : 1000000000000000000,
        .MilliEther : 1000000000000000,
        .MicroEther : 1000000000000,
        .Gwei       : 1000000000,
        .Mwei       : 1000000,
        .Kwei       : 1000,
        .Wei        : 1
    ]

    private static var currencyUnits: [EthereumUnit] = [.Ether, .MilliEther, .MicroEther, .Gwei, .Mwei, .Kwei, .Wei]
    
    public static var Keys : [EthereumUnit] {
        get {
            return conversions.keysSortedByValue(<)
        }
    }
    
    public static var OCKeys : [OCEthereumUnit] {
        get {
            return ocConversions.keysSortedByValue(<)
        }
    }
    
    private static func toEthereumUnit(_ ocUnit: OCEthereumUnit)->EthereumUnit {
        return currencyUnits[ocUnit.rawValue]
    }
    
    public static func toWei(_ value:Double, from:OCEthereumUnit) -> Double {
        return value * ocConversions[from]!
    }
    
    public static func toWei(_ value:Double, from:EthereumUnit) -> Double {
        return value * conversions[from]!
    }

    public static func fromWei(_ value:Double, to:OCEthereumUnit) -> Double {
        return value / ocConversions[to]!
    }

    public static func fromWei(_ value:Double, to:EthereumUnit) -> Double {
        return value / conversions[to]!
    }
    
    public static func convert(currentUnit:OCEthereumUnit, value:Double, to:OCEthereumUnit) -> Double {
        return toWei(value, from: currentUnit) / ocConversions[to]!
    }
    
    public static func convert(currentUnit:EthereumUnit, value:Double, to:EthereumUnit) -> Double {
        return toWei(value, from: currentUnit) / conversions[to]!
    }

    public static func getBestUnit(_ weiValue:Double) -> OCEthereumUnit {
        var bestUnit : OCEthereumUnit = .Wei
        let keys = ocConversions.keysSortedByValue(<)
        keys.forEach { (key) in
            let val = ocConversions[key]
            let nVal = weiValue/val!
            if nVal >= 1 {
                bestUnit =  key
                return
            }
        }
        return bestUnit
    }

    public static func getBestUnit(_ weiValue:Double) -> EthereumUnit {
        var bestUnit : EthereumUnit = .Wei
        let keys = conversions.keysSortedByValue(<)
        keys.forEach { (key) in
            let val = conversions[key]
            let nVal = weiValue/val!
            if nVal >= 1 {
                bestUnit =  key
                return
            }
        }
        return bestUnit
    }
}


extension Dictionary {
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(_ isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sorted() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
            }
    }
}
