//
//  Action.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import CoreData
import Foundation

class Action: NSManagedObject {
    @NSManaged public var actionId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var effectLevel: NSNumber?
    @NSManaged public var has_peripheralIsland: PeripheralIsland?

    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext

        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Action", in: managedObjectContext)

        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
}
