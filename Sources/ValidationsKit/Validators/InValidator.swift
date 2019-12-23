//
//  InValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T: Equatable {

    /// Validates wheter an item is contained in the supplied array.
    public static func `in`(_ array: T...) -> Validator<T> {
        return .in(array)
    }

    /// Validates wheter an item is contained in the supplied array.
    public static func `in`(_ array: [T]) -> Validator<T> {
        return InValidator(array).validator()
    }

}

/// Validates wheter an item is contained in the supplied array.
fileprivate struct InValidator<T: Equatable>: ValidatorType {

    /// Array to check against.
    private let array: [T]

    /// See `ValidatorType`.
    var readable: String {
        let all = array.map { "\($0)" }.joined(separator: ", ")
        let localised = NSLocalizedString("in %@", comment: "'InValidator' readable")
        return String(format: localised, all)
    }

    /// Creates a new `InValidator`.
    init(_ array: [T]) {
        self.array = array
    }

    /// See `ValidatorType`.
    public func validate(_ item: T) throws {
        guard !array.contains(item) else { return }
        let localised = NSLocalizedString("isn't %@", comment: "'InValidator' error message")
        throw BasicValidationError(String(format: localised, readable))
    }

}
