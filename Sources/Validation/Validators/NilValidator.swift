//
//  NilValidator.swift
//  Validation
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T: OptionalType {

    /// Validates that data is `nil`.
    /// Combine with the `NotValidator` to validate that data is not `nil`.
    public static var `nil`: Validator<T.WrappedType?> {
        return NilValidator(T.WrappedType.self).validator()
    }

}

/// Validate that data is nil
fileprivate struct NilValidator<T>: ValidatorType {
    typealias ValidationData = T?

    /// See `ValidatorType`
    var readable = "nil"

    /// Creates a new `NilValidator`.
    /// - parameter type: Type of `ValidationData`.
    init(_ type: T.Type) {}

    /// See `ValidatorType`.
    func validate(_ data: T?) throws {
        guard data != nil else { return }
        throw BasicValidationError("isn't nil")
    }

}
