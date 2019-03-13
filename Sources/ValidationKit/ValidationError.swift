//
//  ValidationError.swift
//  ValidationKit
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// A validation error that supports dynamic key paths.
/// These key paths will be automatically combined to support nested validations.
///
/// See `BasicValidatorError` for a default implementation.
public protocol ValidationError: Error {

    /// Key path to the invalid data.
    var path: [String] { get set }

}

/// Errors that can be thrown while working with validation.
public struct BasicValidationError: ValidationError, CustomStringConvertible {

    /// Key path the validation error happened at.
    public var path: [String]

    /// Validation failure.
    public var message: String

    /// Readable description of the `ValidationError`.
    public var description: String {
        guard path.count > 0 else { return "data \(message)" }
        return "'\(path.joined(separator: "."))' \(message)"
    }

    /// Create a new `BasicValidationError`
    /// - parameter message: Error message to display.
    /// - parameter path: KeyPath of the invalid properties.
    public init(_ message: String, _ path: [String] = []) {
        self.message = message
        self.path = path
    }
    
}
