//
//  OrValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

/// Combines two `Validator`s.
/// Succeed if either of the `Validator`s doesn't fail.
public func ||<T>(lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
    return OrValidator(lhs, rhs).validator()
}

/// Combines two `Validator`s.
/// If either is true, the validation will succeed.
fileprivate struct OrValidator<T> : ValidatorType {

    /// Left hand `Validator`.
    private let lhs: Validator<T>

    /// Right hand `Validator`.
    private let rhs: Validator<T>

    /// See `ValidatorType`.
    var readable: String {
        return "\(lhs.readable) or \(rhs.readable)"
    }

    /// Creates a new `OrValidator`
    init(_ lhs: Validator<T>, _ rhs: Validator<T>) {
        self.lhs = lhs
        self.rhs = rhs
    }

    /// See `ValidatorType`.
    func validate(_ data: T) throws {
        do { try lhs.validate(data) }
        catch let left as ValidationError {
            do { try rhs.validate(data) }
            catch let right as ValidationError {
                throw OrValidationError(left, right)
            }
        }
    }

}

/// Error thrown if both validations of an `OrValidator` fails.
fileprivate struct OrValidationError: ValidationError, CustomStringConvertible {

    /// Error thrown by the left `Validator`.
    private var lhs: ValidationError

    /// Error thrown by the right `Validator`.
    private var rhs: ValidationError

    /// See `ValidationError`.
    var path: [String] {
        didSet {
            lhs.path = path + lhs.path
            rhs.path = path + rhs.path
        }
    }

    /// Readable description of `ValidationError`s
    var description: String {
        return "\(lhs) or \(rhs)"
    }

    /// Create a new `OrValidationError`
    init(_ lhs: ValidationError, _ rhs: ValidationError, _ path: [String] = []) {
        self.lhs = lhs
        self.rhs = rhs
        self.path = path
    }

}
