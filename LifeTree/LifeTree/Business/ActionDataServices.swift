//
//  ActionDataServices.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 11/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import CoreData

class ActionDataServices {

    /// Function responsible for creating an action
    /// - parameters:
    ///     - island: action to be saved
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func createAction(action: Action, relatedIsland: PeripheralIsland, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil

            do {
                try ActionDAO.create(action, relatedIsland)
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block:{completion!(raisedError)})
            // execute block in main
            QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }


    /// Function responsible for updating an island
    /// - parameters:
    ///     - island: Island to be updated
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func updatePeripheralIsland(island: PeripheralIsland, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil

            do {
                // save information
                try PeripheralIslandDAO.update(island)
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }

    /// Function responsible for deleting an action
    /// - parameters:
    ///     - island: Action to be deleted
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func deleteAction(action: Action, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil

            do {
                // save information
                try ActionDAO.delete(action)
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }

    /// Function responsible for getting first action
    /// - parameters:
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func getFirstAction(_ completion: ((_ error: Error?, _ action: Action?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil
            var action: Action?

            do {
                // save information
                action = try ActionDAO.findFirst()
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, action)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }

    /// Function responsible for getting all peripheral actions
    /// - parameters:
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func getAllActions(_ completion: ((_ error: Error?, _ actions: [Action]?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil
            var actions: [Action]?

            do {
                // save information
                actions = try ActionDAO.findAll()
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, actions)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }


    static func getIslandActions(island: PeripheralIsland, _ completion: ((_ error: Error?, _ actions: [Action]?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil
            var actions: [Action]? = []

            do {
                // save information
                let allActions = try ActionDAO.findAll()

                for action in allActions {
                    if action.has_peripheralIsland == island {
                        actions?.append(action)
                    }
                }
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, actions)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
}
