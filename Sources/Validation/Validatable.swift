//
//  Validatable.swift
//  Validation
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// Capable of being validated. Conformance adds a throwing `validate()` method.
public protocol Validatable {

    /// The validations that will run when `validate()` is called on an instance of this class.
    static func validations() throws -> Validations<Self>

}

extension Validatable {

    /// Validates the model, throwing an error if any of the validations fails.
    /// - note: Non-validation errors may also be thrown should the validators encounter unexpected errors.
    public func validate() throws {
        try Self.validations().run(on: self)
    }

}
