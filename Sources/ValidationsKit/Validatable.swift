//
//  Validatable.swift
//  ValidationKit
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

    /// Validate a single field of the model, throwing an error is no `Validator` has been defined or if the validations fails.
    /// - parameter keyPath: `KeyPath` of the model to validates.
    public func validate(at keyPath: PartialKeyPath<Self>) throws {
        try Self.validations().run(on: self, at: keyPath)
    }

}
