//
//  BtcUnitConverter.swift
//  EthWallet
//
//  Created by Paul Stinchcombe on 22/5/18.
//  Copyright © 2018 Dragonsoft Research. All rights reserved.
//

import Foundation

@objcMembers public class BtcUnitConverter: NSObject {
    
    @objc public enum OCBitcoinUnit: Int {
        case BTC        = 0
        case CentBTC
        case MilliBTC
        case MicroBTC
        case Finney
        case Satoshi
    }
    
    public enum BitcoinUnit: String {
        case BTC        = "BTC"
        case CentBTC    = "cBTC"
        case MilliBTC   = "mBTC"
        case MicroBTC   = "uBTC"
        case Finney     = "finney"
        case Satoshi    = "Satoshi"
    }
    
    private static var currencyUnits: [String] = ["BTC", "cBTC", "mBTC", "uBTC", "finney", "Satoshi"]
    
    private static let conversions : [BitcoinUnit : Double] = [
        .BTC        : 100000000,
        .CentBTC    : 10000000,
        .MilliBTC   : 1000000,
        .MicroBTC   : 1000,
        .Finney     : 100,
        .Satoshi    : 1
    ]
    
    private static let ocConversions : [OCBitcoinUnit : Double] = [
        .BTC        : 100000000,
        .CentBTC    : 10000000,
        .MilliBTC   : 1000000,
        .MicroBTC   : 1000,
        .Finney     : 100,
        .Satoshi    : 1
    ]
    
    public static var Keys : [BitcoinUnit] {
        get {
            return conversions.keysSortedByValue(<)
        }
    }

    public static var OCKeys : [OCBitcoinUnit] {
        get {
            return ocConversions.keysSortedByValue(<)
        }
    }

    private static func toBitcoinUnit(_ ocUnit: OCBitcoinUnit)->BitcoinUnit {
        let unitName = currencyUnits[ocUnit.rawValue]
        return BitcoinUnit.init(rawValue: unitName)!
    }
    
    public static func toSatoshi(_ value:Double, from:OCBitcoinUnit) -> Double {
        return value * ocConversions[from]!
    }
    
    public static func toSatoshi(_ value:Double, from:BitcoinUnit) -> Double {
        return value * conversions[from]!
    }

    public static func fromSatoshi(_ value:Double, to:OCBitcoinUnit) -> Double {
        return value / ocConversions[to]!
    }

    public static func fromSatoshi(_ value:Double, to:BitcoinUnit) -> Double {
        return value / conversions[to]!
    }
    
    public static func convert(currentUnit:OCBitcoinUnit, value:Double, to:OCBitcoinUnit) -> Double {
        return toSatoshi(value, from: currentUnit) / ocConversions[to]!
    }

    public static func convert(currentUnit:BitcoinUnit, value:Double, to:BitcoinUnit) -> Double {
        return toSatoshi(value, from: currentUnit) / conversions[to]!
    }
    
    public static func getBestUnit(_ satoshiValue:Double) -> OCBitcoinUnit {
        var bestUnit : OCBitcoinUnit = .Satoshi
        let keys = ocConversions.keysSortedByValue(<)
        keys.forEach { (key) in
            let val = ocConversions[key]
            let nVal = satoshiValue/val!
            if nVal >= 1 {
                bestUnit =  key
                return
            }
        }
        return bestUnit
    }

    public static func getBestUnit(_ satoshiValue:Double) -> BitcoinUnit {
        var bestUnit : BitcoinUnit = .Satoshi
        let keys = conversions.keysSortedByValue(<)
        keys.forEach { (key) in
            let val = conversions[key]
            let nVal = satoshiValue/val!
            if nVal >= 1 {
                bestUnit =  key
                return
            }
        }
        return bestUnit
    }
}



