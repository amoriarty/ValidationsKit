//
//  CountValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T: Collection {

    /// Validates that the collection count is within the supplied `Range`.
    public static func count(_ range: Range<Int>) -> Validator<T> {
        return CountValidator(min: range.lowerBound, max: range.upperBound.advanced(by: -1)).validator()
    }

    /// Validates that the collection count is within the supplied `ClosedRange`.
    public static func count(_ range: ClosedRange<Int>) -> Validator<T> {
        return CountValidator(min: range.lowerBound, max: range.upperBound).validator()
    }

    /// Validates that the collection count is less thant the supplied upper bound using `PartialRangeThrough`.
    public static func count(_ range: PartialRangeThrough<Int>) -> Validator<T> {
        return CountValidator(min: nil, max: range.upperBound).validator()
    }

    /// Validates that the collection count is less than the supplied lower bound using `PartialRangeFrom`.
    public static func count(_ range: PartialRangeFrom<Int>) -> Validator<T> {
        return CountValidator(min: range.lowerBound, max: nil).validator()
    }

}

/// Validates that number of items in collection is in range.
private struct CountValidator<T: Collection>: ValidatorType {

    /// Minimum inclusive possible value, not checked if nil.
    private let min: Int?

    /// Maximum inclusive possible value, not checked if nil.
    private let max: Int?

    /// See `ValidatorType`
    var readable: String {
        if let min = min, let max = max {
            return "between \(min) and \(element(for: max))"
        } else if let min = min {
            return "at least \(element(for: min))"
        } else if let max = max {
            return "at most \(element(for: max))"
        } else {
            return "valid"
        }
    }

    init(min: Int?, max: Int?) {
        self.min = min
        self.max = max
    }

    /// See `ValidatorType`.
    func validate(_ collection: T) throws {
        let min = self.min ?? 0
        let max = self.max ?? collection.count

        guard collection.count >= min else {
            throw BasicValidationError("is less than required minimum of \(element(for: min))")
        }

        guard collection.count <= max else {
            throw BasicValidationError("is greater than required maximum of \(element(for: max))")
        }
    }

    /// Get the correct `String` to print if a validation error is thrown.
    /// - parameter count: Count of element, allowing to defined if an 's' should be placed at the end.
    private func element(for count: Int) -> String {
        let type = T.Element.self is Character.Type ? "character" : "item"
        return "\(count) \(type)\(count == 1 ? "" : "s")"
    }

}
