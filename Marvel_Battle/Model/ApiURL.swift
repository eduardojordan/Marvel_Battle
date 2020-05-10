//
//  ApiURL.swift
//  Marvel_Battle
//
//  Created by MAC on 09/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import Foundation
import CryptoSwift


class ApiURL{
    
    static let basePath = "https://gateway.marvel.com/v1/public"
    static let pathCharacters = "/characters?"
    static let limit = 200
    static private let privateKey = Constants.API_KEY_PRIVATE
    static private let publicKey = Constants.API_KEY_PUBLIC
    
    static func getCredentials() -> String{
        let ts = Date().timeIntervalSince1970.description
        let hash = "\(ts)\(privateKey)\(publicKey)".md5()
        let authParams = ["ts": ts, "apikey": publicKey, "hash": hash]
        print(authParams)
        return authParams.queryString!
    }
    
}
