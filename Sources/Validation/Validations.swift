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

    /// Runs the `Validation`s on an instance of `Model`.
    func run(on model: Model) throws {
        for validation in storage {
            try validation.validate(model)
        }
    }

}
