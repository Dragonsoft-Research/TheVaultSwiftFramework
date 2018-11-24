//
//  DataManager.swift
//  The Vault
//
//  Created by Amy on 19/11/2018.
//  Copyright © 2018 World Quest. All rights reserved.
//

import UIKit

public class DataManager {
    
    static fileprivate func getDocumentDirectory() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }
        else {
            fatalError("Unable to access document directory")
        }
    }
    
    
//    fileprivate static func genericName<T:Codable>(_ type: T.Type) -> String {
//        let fullName: String = NSStringFromClass(T.self)
//        let range = fullName.range(of: ".")
//        if let range = range {
//            return fullName.substring(from: range.upperBound)
//        }
//        return fullName
//    }
    
    //save any kind of codable data objects
    static func save <T:Encodable> (_ object: T) {
        let fileName: String = String(describing: T.self)
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path){
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    //save any kind of codable data objects
    static func save <T:Encodable> (_ object: T, with fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path){
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func load <T:Decodable> (with type: T.Type) -> T? {
        let fileName: String = String(describing: T.self)
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            return nil
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }
            catch {
//                fatalError(error.localizedDescription)
                return nil
            }
        }
        else {
//            fatalError("data unavailable at path \(url.path)")
            return nil
        }
    }
    
    //load any kind of codable objects
    static func load <T:Decodable> (_ fileName: String, with type: T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("file not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        else {
            fatalError("data unavailable at path \(url.path)")
        }
    }
    
    //load data from a file
    static func loadData (_ fileName: String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("file not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            return data
        }
        else {
            fatalError("data unavailable at path \(url.path)")
        }
    }
    
    //load all files from a directory
    static func loadAll <T:Decodable> (_ type: T.Type) -> [T] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            var modelObject = [T]()
            for fileName in files {
                modelObject.append(load(fileName, with: type))
            }
            return modelObject
        }
        catch {
            fatalError("could not load any files")
        }
    }
    
    //delete
    static func delete (_ fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.removeItem(at: url)
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

