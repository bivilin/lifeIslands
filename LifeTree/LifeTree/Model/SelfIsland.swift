//
//  SelfIsland.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 23/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import CoreData

class SelfIsland: NSManagedObject {
    @NSManaged public var islandId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var currentHealthStatus: NSNumber?
    @NSManaged public var lastHealthStatus: NSNumber?
    
    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "SelfIsland", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
    
}

