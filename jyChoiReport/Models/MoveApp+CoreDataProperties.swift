//
//  MoveApp+CoreDataProperties.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/21/24.
//
//

import Foundation
import CoreData


extension MoveApp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoveApp> {
        return NSFetchRequest<MoveApp>(entityName: "MoveApp")
    }
    
    @NSManaged public var checkID: String?
    @NSManaged public var urlNews: URL?

}

extension MoveApp : Identifiable {

}
