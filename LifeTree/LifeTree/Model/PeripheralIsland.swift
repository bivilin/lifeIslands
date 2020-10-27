//
//  PeriferalIsland.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import CoreData

class PeripheralIsland: NSManagedObject {
    @NSManaged public var islandId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var currentHealthStatus: NSNumber?
    @NSManaged public var lastHealthStatus: NSNumber?
    @NSManaged public var lastActionDate: Date?
    @NSManaged public var has_action: Action?

    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext

        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "PeripheralIsland", in: managedObjectContext)

        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
}
