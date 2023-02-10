//
//  Config.swift
//  Agora Stream Commentary
//
//  Created by shaun on 2/10/23.
//

import Foundation

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var agoraAppID: String {        return try! Configuration.value(for: "AGORA_APP_ID")
    }
}

