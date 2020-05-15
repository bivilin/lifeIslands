//
//  Errors.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 23/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

enum Errors: Error, Equatable{
    case DatabaseFailure
    // There was a problem on the database.
    case CreateLimitExceeded
    // Check if you are creating more objects than necessary. Rules for limits are on Services classes.
    case InvalidImpactLevel
    // Impact level range only from 1 up to 5. Check if your value is not integer or if it's outside the range.
}
