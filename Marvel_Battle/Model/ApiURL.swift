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
    static let limit = 80
    static private let privateKey = "5caaca8f42ab034276ef21802379e48072601df0"
    static private let publicKey = "30f82da5469dc0b00aab3559f26e2047"

    
    static func getCredentials() -> String{
        let ts = Date().timeIntervalSince1970.description
        let hash = "\(ts)\(privateKey)\(publicKey)".md5()
        let authParams = ["ts": ts, "apikey": publicKey, "hash": hash]
        print(authParams)
        return authParams.queryString!
    }
    
}
