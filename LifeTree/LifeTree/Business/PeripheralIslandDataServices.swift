//
//  PeripheralIslandDataServices.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 28/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import CoreData

class PeripheralIslandDataServices {

    /// Function responsible for creating an island
    /// - parameters:
    ///     - island: Island to be saved
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func createAllPeripheralIsland(islands: [PeripheralIsland], _ completion: ((_ error: Error?) -> Void)?)  {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil

            self.getAllPeripheralIslands { (error, peripheralIslands) in
                if let allIslands = peripheralIslands {
                    if (error != nil) {
                        print(error.debugDescription)
                    } else if allIslands.count < 6 {
                        do {
                            for island in islands {
                                try PeripheralIslandDAO.create(island)
                            }
                        }
                        catch let error {
                            raisedError = error
                        }
                    } else {
                        raisedError = Errors.CreateLimitExceeded
                        print("Maximum Limit of PeripheralIsland Exceeded.")
                    }
                }

                // completion block execution
                if (completion != nil) {
                    let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})

                    // execute block in main
                    QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
                }
            }

        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }

    /// Function responsible for creating an island
    /// - parameters:
    ///     - island: Island to be saved
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func createPeripheralIsland(island: PeripheralIsland, _ completion: ((_ error: Error?) -> Void)?)  {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil

            self.getAllPeripheralIslands { (error, peripheralIslands) in
                if let allIslands = peripheralIslands {
                    if (error != nil) {
                        print(error.debugDescription)
                    } else if allIslands.count < 6 {
                        do {
                            try PeripheralIslandDAO.create(island)
                        }
                        catch let error {
                            raisedError = error
                        }
                    } else {
                        raisedError = Errors.CreateLimitExceeded
                        print("Maximum Limit of PeripheralIsland Exceeded.")
                    }
                }

                // completion block execution
                if (completion != nil) {
                    let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})

                    // execute block in main
                    QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
                }
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

    /// Function responsible for deleting an island
    /// - parameters:
    ///     - island: Island to be deleted
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func deletePeripheralIsland(island: PeripheralIsland, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil

            do {
                // save information
                try PeripheralIslandDAO.delete(island)
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

    /// Function responsible for getting all islands
    /// - parameters:
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func getFirstPeripheralIsland(_ completion: ((_ error: Error?, _ peripheralIsland: PeripheralIsland?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil
            var peripheralIsland: PeripheralIsland?

            do {
                // save information
                peripheralIsland = try PeripheralIslandDAO.findFirst()
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, peripheralIsland)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }

    /// Function responsible for getting all peripheral islands
    /// - parameters:
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func getAllPeripheralIslands(_ completion: ((_ error: Error?, _ peripheralIslands: [PeripheralIsland]?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error? = nil
            var peripheralIslands: [PeripheralIsland]?

            do {
                // save information
                peripheralIslands = try PeripheralIslandDAO.findAll()
            }
            catch let error {
                raisedError = error
            }

            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, peripheralIslands)})

                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })

        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
}
