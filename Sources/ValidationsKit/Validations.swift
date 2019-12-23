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
        storage[keyPath] = Validator<Model>(
            readable,
            message: message != nil ? { model in message!(model[keyPath: keyPath]) } : nil
        ) { model in
            do { try validator(model[keyPath: keyPath]) }
            catch {
                guard var err = error as? ValidationError else { throw error }
                err.path = path
                throw err
            }
        }
    }

    /// Runs the `Validation`s on an instance of `Model`.
    /// - parameter model: Model on which validation must be done.
    func run(on model: Model) throws {
        for (_, validation) in storage {
            try validation.validate(model)
        }
    }

    /// Run a validation on a single field specified at `keyPath`.
    /// - parameter model: Model on which validation must be done.
    /// - parameter keyPath: `KeyPath` of the model to be validate.
    func run(on model: Model, at keyPath: PartialKeyPath<Model>) throws {
        guard let validation = storage[keyPath] else {
            throw UndefinedValidationError()
        }

        try validation.validate(model)
    }

}
