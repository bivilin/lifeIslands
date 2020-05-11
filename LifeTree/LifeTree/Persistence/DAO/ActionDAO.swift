//
//  ActionDAO.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 11/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import CoreData

class ActionDAO: DAO {

    /// Method responsible for saving an action into database
    /// - parameters:
    ///     - objectToBeSaved: action to be saved on database
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func create(_ objectToBeSaved: Action, _ relatedIsland: PeripheralIsland) throws {
        do {
            // add object to be saved to the context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.insert(objectToBeSaved)

            // includes relationship between action and peripheral island
            relatedIsland.managedObjectContext?.insert(objectToBeSaved)

            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }

    /// Method responsible for updating an action into database
    /// - parameters:
    ///     - objectToBeUpdated: action to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update(_ objectToBeUpdated: Action) throws {
        do {
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }

    /// Method responsible for deleting an action from database
    /// - parameters:
    ///     - objectToBeSaved: action to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ objectToBeDeleted: Action) throws {
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

    /// Method responsible for retrieving first created action from database
    /// - returns: the first created action from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findFirst() throws -> Action? {
        // list of islands to be returned
        var actionList:[Action]

        do {
            // creating fetch request
            let request:NSFetchRequest<Action> = fetchRequest()

            // perform search
            actionList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }

        if actionList.count > 0 {
            return actionList[0]
        } else {
            return nil
        }
    }

    /// Method responsible for retrieving all actions from database
    /// - returns: a list of actions from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findAll() throws -> [Action] {
        // list of projects to be returned
        var actionList:[Action]

        do {
            // creating fetch request
            let request:NSFetchRequest<Action> = fetchRequest()

            // perform search
            actionList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }

        return actionList
    }

}
