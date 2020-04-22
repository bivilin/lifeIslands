//
//  SelfIsland.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import CoreData

class SelfIsland: NSManagedObject {
    @NSManaged public var islandId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var healthStatus: NSNumber?
    
    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "SelfIsland", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
    
}

