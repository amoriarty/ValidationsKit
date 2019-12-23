//
//  Validator.swift
//  ValidationKit
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// A discret `Validator`. Usually created by calling `ValidatorType.validator()`
public struct Validator<T> {

    /// Readable name explaining what this `Validator` does. Must be suitable for placing after `is` _and_ `is not`.
    public var readable: String

    /// Error message provided by the user to throw in case of validation failure
    private let message: ((T) -> String)?

    /// Validates the supplied `ValidationData`, throwing an error if it is not valid.
    /// - parameter data: `ValidationData` to validate.
    /// - throws: `ValidationError` if the data is not valid, or another error if something fails.
    private let validator: (T) throws -> Void

    /// Create a new `Validation`.
    /// - parameter readable: Readable name, suitable for placing after `is` _and_ `is not`.
    /// - parameter message: Error message provided by the user to throw in case of validation failure
    /// - parameter validate: Validates the supplied `ValidationData`, throwing and error if it is not valid.
    public init(_ readable: String, message: ((T) -> String)? = nil, _ validator: @escaping (T) throws -> Void) {
        self.readable = readable
        self.message = message
        self.validator = validator
    }

    /// Validates the supplied `ValidationData`, throwing an error if it is not valid.
    /// - parameter data: `ValidationData` to validate.
    /// - throws: `ValidationError` if the data is not valid, or another error if something fails.
    public func validate(_ data: T) throws {
        do {
            try validator(data)
        } catch {
            guard let message = message else { throw error }
            throw CustomValidationError(message(data))
        }
    }

}
