//
//  ReflectableError.swift
//  ValidationsKit
//
//  Created by Alexandre Legent on 24/12/2019.
//

import Foundation

/// Error thrown by reflectable system (replacement of vapor `CoreError`)
enum ReflectableError: Error {

    /// Given model doesn't conform to `Reflectable`
    case doesNotConform

    /// Enum needs at least two cases to conform to `Reflectable`
    case enumNeedTwoCases

}
