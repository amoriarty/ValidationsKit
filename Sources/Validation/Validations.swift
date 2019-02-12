//
//  Validations.swift
//  Validation
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// Holds zero or more validations for a `Validatable` model.
public struct Validations<Model> where Model: Validatable {

    /// Internal `Validator`s storage.
    private var storage: [Validator<Model>]

    /// Create an empty `Validations` struct.
    public init(_ model: Model.Type) {
        storage = []
    }

    /// Adds a new `Validation` at the supplied key path and readable path.
    /// - parameter keyPath: `KeyPath` to validatable property.
    /// - parameter path: Readable path. Will be displayed when showing errors.
    /// - parameter validator: `Validator` to run on this property.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>, at path: [String], _ validator: Validator<T>) {
        let validation = Validator<Model>(validator.readable) { model in
            try validator.validate(model[keyPath: keyPath])
        }

        storage.append(validation)
    }

    /// Runs the `Validation`s on an instance of `Model`.
    func run(on model: Model) throws {
        for validation in storage {
            try validation.validate(model)
        }
    }

}
