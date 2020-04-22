//
//  UserDAO.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 27/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import CoreData

class SelfIslandDAO: DAO {
    
    /// Method responsible for saving a project into database
    /// - parameters:
    ///     - objectToBeSaved: project to be saved on database
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func create(_ objectToBeSaved: SelfIsland) throws {
        do {
            // add object to be saved to the context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.insert(objectToBeSaved)
            
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for updating a project into database
    /// - parameters:
    ///     - objectToBeUpdated: project to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update(_ objectToBeUpdated: SelfIsland) throws {
        do {
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for deleting a project from database
    /// - parameters:
    ///     - objectToBeSaved: project to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ objectToBeDeleted: SelfIsland) throws {
        do {
            // delete element from context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(objectToBeDeleted)
            
            // persist the operation
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }

    /// Method responsible for retrieving all projects from database
    /// - returns: a list of projects from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findAll() throws -> [SelfIsland] {
        // list of projects to be returned
        var selfIslandList:[SelfIsland]

        do {
            // creating fetch request
            let request:NSFetchRequest<SelfIsland> = fetchRequest()

            // perform search
            selfIslandList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }

        return selfIslandList
    }
}
