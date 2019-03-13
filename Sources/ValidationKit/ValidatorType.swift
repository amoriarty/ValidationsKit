//
//  ValidatorType.swift
//  ValidationKit
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// Capable of validating `ValidationData` or throwing a validation error.
/// Use this protocol to organize code for creating `Validator`s.
public protocol ValidatorType {

    /// Data type to validate.
    associatedtype ValidationData

    /// Readable name explaining what this `Validator` does. Suitable for placing after `is` _and_ `is not`.
    var readable: String { get }

    /// Validate the supplied `ValidationData`, throwing an error if it is not valid.
    func validate(_ data: ValidationData) throws

}

extension ValidatorType {

    /// Create a `Validator` for this `ValidatorType`.
    public func validator() -> Validator<ValidationData> {
        return Validator(readable, validate)
    }

}
