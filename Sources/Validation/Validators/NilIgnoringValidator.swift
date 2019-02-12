//
//  NilIgnoringValidator.swift
//  Validation
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

/// Combines an optional and non-optional `Validator` using OR logic.
/// The non-optional validator will simply ignore `nil` values, assuming the other `Validator` handles them.
public func ||<T>(lhs: Validator<T?>, rhs: Validator<T>) -> Validator<T?> {
    return lhs || NilIgnoringValidator(rhs).validator()
}

/// Combines an optional and non-optional `Validator` using OR logic.
/// The non-optional validator will simply ignore `nil` values, assuming the other `Validator` handles them.
public func ||<T>(lhs: Validator<T>, rhs: Validator<T?>) -> Validator<T?> {
    return NilIgnoringValidator(lhs).validator() || rhs
}
/// Combines an optional and non-optional `Validator` using AND logic.
/// The non-optional validator will simply ignore `nil` values, assuming the other `Validator` handles them.
public func &&<T>(lhs: Validator<T?>, rhs: Validator<T>) -> Validator<T?> {
    return lhs && NilIgnoringValidator(rhs).validator()
}
/// Combines an optional and non-optional `Validator` using AND logic.
/// The non-optional validator will simply ignore `nil` values, assuming the other `Validator` handles them.
public func &&<T>(lhs: Validator<T>, rhs: Validator<T?>) -> Validator<T?> {
    return NilIgnoringValidator(lhs).validator() && rhs
}

/// A `Validator` that ignore nil values.
fileprivate struct NilIgnoringValidator<T>: ValidatorType {

    /// Right hand `Validator`
    private let validator: Validator<T>

    /// See `ValidatorType`.
    var readable: String {
        return validator.readable
    }

    /// Creates a new `NilIgnoringValidator`.
    /// - parameter validator: Right hand validator.
    init(_ validator: Validator<T>) {
        self.validator = validator
    }

    /// See `ValidatorType`.
    func validate(_ data: T?) throws {
        guard let data = data else { return }
        try validator.validate(data)
    }

}
