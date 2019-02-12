//
//  NotValidator.swift
//  Validation
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

/// Inverts a `Validator`.
public prefix func !<T>(validator: Validator<T>) -> Validator<T> {
    return NotValidator(validator).validator()
}

/// Inverts a `Validator`.
fileprivate struct NotValidator<T>: ValidatorType {

    /// The `Validator` to invert.
    private let validator: Validator<T>

    /// See `ValidatorType`.
    var readable: String {
        return "not \(validator.readable)"
    }

    /// Create a new `NotValidator`.
    init(_ validator: Validator<T>) {
        self.validator = validator
    }

    /// See `ValidatorType`
    func validate(_ data: T) throws {
        do { try validator.validate(data) }
        catch _ as ValidationError { return }
        throw BasicValidationError("is \(validator.readable)")
    }

}
