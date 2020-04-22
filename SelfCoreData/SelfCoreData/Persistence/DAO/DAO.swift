//
//  DAO.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 27/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import CoreData

/// Data Access Object base class
/// Every DAO should extend this class
class DAO {
    
    /// Helper method to build a NSFetchRequest with an entity considering that
    /// the Entity Name matches the resulting class name
    /// - Returns: Fetch Request of Result Type, is the class that represents the Request.entity
    static func fetchRequest<ResultType>() -> NSFetchRequest<ResultType>
    {
        let entityName = String(describing: ResultType.self)
        
        let request:NSFetchRequest = NSFetchRequest<ResultType>(entityName: entityName)
        
        return request
    }
}
