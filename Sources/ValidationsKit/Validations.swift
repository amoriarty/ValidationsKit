//
//  Validations.swift
//  ValidationKit
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// Holds zero or more validations for a `Validatable` model.
public struct Validations<Model> where Model: Validatable {

    /// Internal `Validator`s storage.
    private var storage: [PartialKeyPath<Model>: Validator<Model>]

    /// Create an empty `Validations` struct.
    public init(_ model: Model.Type) {
        storage = [:]
    }

    /// Adds a new `Validation` at the supplied key path.
    /// - parameter keyPath: `KeyPath` to validatable property.
    /// - parameter path: Readable path. Will be displayed when showing errors.
    /// - parameter validator: `Validator` to run on this property.
    /// - parameter message: Error message provided by the user and throw in case of validation error.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>,
                                at path: [String],
                                _ validator: Validator<T>,
                                message: ((T) -> String)? = nil) {
        add(keyPath, at: path, validator.readable, validator: validator.validate, message: message)
    }

    /// Adds a custom validation at the supplied key path and readable.
    /// - parameter keyPath: `KeyPath` to validatable property.
    /// - parameter path: Readable path. Will be displayed when showing errors.
    /// - parameter readable: Readable message. Will be displayed when showing errors.
    /// - parameter validator: Validation closure.
    /// - parameter message: Error message provided by the user and throw in case of validation error.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>,
                                at path: [String],
                                _ readable: String = "",
                                validator: @escaping (T) throws -> Void,
                                message: ((T) -> String)? = nil) {
        add(keyPath, at: path, readable, withModel: { try validator($0[keyPath: keyPath]) }, message: message)
    }

    /// Adds a custom validation at the supplied key path and readable,
    /// with validator taking whole model instead of just the supplied key path.
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` associated with validation.
    ///     - path: Readable path. Will be displayed when showing errors.
    ///     - readable: Readable message. Will be displayed when showing errors.
    ///     - validation: Validation closure with full model.
    ///     - message: Error message provided by the user and throw in case of validation error.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>,
                                at path: [String],
                                _ readable: String = "",
                                withModel validator: @escaping (Model) throws -> Void,
                                message: ((T) -> String)? = nil) {
        storage[keyPath] = Validator<Model>(
            readable,
            message: message != nil ? { model in message!(model[keyPath: keyPath]) } : nil,
            validator: { model in
                do {
                    try validator(model)
                } catch {
                    guard var err = error as? ValidationError else { throw error }
                    err.path = path
                    throw err
                }
            }
        )
    }

}

// MARK: - Reflectable

extension Validations where Model: Reflectable {

    /// Adds a new `Validation` at the supplied key path. Readable path will be reflected.
    ///
    ///     try validations.add(\.name, .count(5...) && .alphanumeric)
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - validator: `Validation` to run on this property.
    ///     - message: Error message provided by the user and throw in case of validation error.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>,
                                _ validator: Validator<T>,
                                _ message: ((T) -> String)? = nil) throws {
        try add(keyPath, at: Model.reflectProperty(forKey: keyPath)?.path ?? [], validator, message: message)
    }

    /// Adds a new custom `Validation` at the supplied key path. Readable path will be reflected.
    ///
    ///     try validations.add(\.name, "is vapor") { name in
    ///         guard name == "vapor" else { throw }
    ///     }
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to validatable property.
    ///     - readable: Readable string describing this validation.
    ///     - validator: Closure accepting the `KeyPath`'s value. Throw a `ValidationError` here if the data is invalid.
    ///     - message: Error message provided by the user and throw in case of validation error.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>,
                                _ readable: String = "",
                                validator: @escaping (T) throws -> Void,
                                message: ((T) -> String)? = nil) throws {
        try add(
            keyPath,
            at: Model.reflectProperty(forKey: keyPath)?.path ?? [],
            readable,
            validator: validator,
            message: message
        )
    }

}

// MARK: - Run

extension Validations {

    /// Runs the `Validation`s on an instance of `Model`.
    /// - parameter model: Model on which validation must be done.
    func run(on model: Model) throws {
        for (_, validation) in storage {
            try validation.validate(model)
        }
    }

    /// Run a validation on defined fields specified at `keyPaths`.
    /// - parameter model: Model on which validation must be done.
    /// - parameter keyPaths: `KeyPath`s of the model to be validate.
    func run(on model: Model, at keyPaths: PartialKeyPath<Model>...) throws {
        try run(on: model, at: keyPaths)
    }

    /// Run a validation on defined fields specified at `keyPaths`.
    /// - parameter model: Model on which validation must be done.
    /// - parameter keyPaths: `KeyPath`s of the model to be validate.
    func run(on model: Model, at keyPaths: [PartialKeyPath<Model>]) throws {
        try keyPaths.forEach { keyPath in
            guard let validation = storage[keyPath] else {
                throw UndefinedValidationError()
            }

            try validation.validate(model)
        }
    }

}
