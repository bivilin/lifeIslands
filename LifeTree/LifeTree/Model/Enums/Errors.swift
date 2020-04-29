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
    case CreateLimitExceeded
}
