//
//  EmptyValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T: Collection {

    /// Validates that the collection is empty.
    /// You can also check a non empty state by combining with the `NotValidator`
    public static var empty: Validator<T> {
        return EmptyValidator().validator()
    }

}

/// Validates wheter the collection is empty.
private struct EmptyValidator<T: Collection>: ValidatorType {

    /// See `ValidatorType`
    let readable = "empty"

    /// See `ValidatorType`
    func validate(_ collection: T) throws {
        guard !collection.isEmpty else { return }
        throw BasicValidationError("is not empty")
    }

}
