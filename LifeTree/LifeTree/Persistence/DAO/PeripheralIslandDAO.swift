//
//  PeripheralIslandDAO.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 28/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import CoreData

class PeripheralIslandDAO: DAO {

    /// Method responsible for saving an island into database
    /// - parameters:
    ///     - objectToBeSaved: island to be saved on database
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func create(_ objectToBeSaved: PeripheralIsland) throws {
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

    /// Method responsible for updating an island into database
    /// - parameters:
    ///     - objectToBeUpdated: island to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update(_ objectToBeUpdated: PeripheralIsland) throws {
        do {
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }

    /// Method responsible for deleting an island from database
    /// - parameters:
    ///     - objectToBeSaved: island to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ objectToBeDeleted: PeripheralIsland) throws {
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

    /// Method responsible for retrieving first created island from database
    /// - returns: the first created island from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findFirst() throws -> PeripheralIsland? {
        // list of islands to be returned
        var peripheralIslandList:[PeripheralIsland]

        do {
            // creating fetch request
            let request:NSFetchRequest<PeripheralIsland> = fetchRequest()

            // perform search
            peripheralIslandList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }

        if peripheralIslandList.count > 0 {
            return peripheralIslandList[0]
        } else {
            return nil
        }
    }

    /// Method responsible for retrieving all peripheral islands from database
    /// - returns: a list of peripheral islands from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findAll() throws -> [PeripheralIsland] {
        // list of projects to be returned
        var peripheralIslandList:[PeripheralIsland]

        do {
            // creating fetch request
            let request:NSFetchRequest<PeripheralIsland> = fetchRequest()

            // perform search
            peripheralIslandList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }

        return peripheralIslandList
    }

}
