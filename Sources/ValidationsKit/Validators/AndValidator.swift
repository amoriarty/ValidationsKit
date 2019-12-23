//
//  AndValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

/// Combines two `Validator`s using AND logic.
/// Succeeding if both `Validator`s succeed without error.
public func &&<T>(lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
    return AndValidator(lhs, rhs).validator()
}

/// Combines two `Validator`s.
/// If either both succeed, the validation will succeed.
fileprivate struct AndValidator<T>: ValidatorType {

    /// Left hand `Validator`.
    private let lhs: Validator<T>

    /// Right hand `Validator`.
    private let rhs: Validator<T>

    /// See `ValidatorType`.
    var readable: String {
        let localised = NSLocalizedString("%@ and %@", comment: "'AndValidator' readable")
        return String(format: localised, lhs.readable, rhs.readable)
    }

    /// Create a new `AndValidator`.
    init(_ lhs: Validator<T>, _ rhs: Validator<T>) {
        self.lhs = lhs
        self.rhs = rhs
    }

    /// See `ValidatorType`.
    func validate(_ data: T) throws {
        try lhs.validate(data)
        try rhs.validate(data)
    }

}
