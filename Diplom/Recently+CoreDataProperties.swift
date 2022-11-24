//
//  Recently+CoreDataProperties.swift
//  Diplom
//
//  Created by Nor1 on 08.11.2022.
//
//

import Foundation
import CoreData


extension Recently {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recently> {
        return NSFetchRequest<Recently>(entityName: "Recently")
    }

    @NSManaged public var name: String?
    @NSManaged public var created: String?
    @NSManaged public var path: String?
    @NSManaged public var type: String?
    @NSManaged public var file: String?
    @NSManaged public var preview: String?
    @NSManaged public var media_type: String?
    @NSManaged public var total: String?
    @NSManaged public var size: Double

}

extension Recently : Identifiable {

}
