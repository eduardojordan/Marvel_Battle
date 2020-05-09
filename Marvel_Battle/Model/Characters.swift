//
//  Characters.swift
//  Marvel_Battle
//
//  Created by MAC on 09/05/2020.
//  Copyright © 2020 eduardojordan.com. All rights reserved.
//

import Foundation

struct Characters: Decodable {
    var data: ResultsCharacters?
}

struct ResultsCharacters: Decodable {
    var results: [DataCharacter]
}

struct DataCharacter: Decodable {
    
    var id: Int?
    var name: String?
    var description: String?
    var image: URL?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case description
        case thumbnail
        case image = "path"
        
    }
    
    init(from decoder: Decoder)throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        let containerImage = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnail)
        image = try containerImage.decode(URL.self, forKey: .image)
    }
    
}
