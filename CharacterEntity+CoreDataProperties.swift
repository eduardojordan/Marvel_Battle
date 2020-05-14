//
//  CharacterEntity+CoreDataProperties.swift
//  
//
//  Created by MAC on 14/05/2020.
//
//

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var combatWinner: Int64
    @NSManaged public var nameChracter: String?
    @NSManaged public var descriptionCharacter: String?
    @NSManaged public var imageCharacter: String?

}
