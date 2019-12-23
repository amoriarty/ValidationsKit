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
fileprivate struct CountValidator<T: Collection>: ValidatorType {

    /// Minimum inclusive possible value, not checked if nil.
    private let min: Int?

    /// Maximum inclusive possible value, not checked if nil.
    private let max: Int?

    /// See `ValidatorType`
    var readable: String {
        if let min = min, let max = max {
            let localised = NSLocalizedString("between %@ and %@ %@", comment: "'CountValidator' readable")
            return String(format: localised, "\(min)", "\(max)", element(for: max))
        } else if let min = min {
            let localised = NSLocalizedString("at least %@ %@", comment: "'CountValidator' readable")
            return String(format: localised, "\(min)", element(for: min))
        } else if let max = max {
            let localised = NSLocalizedString("at most %@ %@", comment: "'CountValidator' readable")
            return String(format: localised, "\(max)", element(for: max))
        } else {
            return NSLocalizedString("valid", comment: "'CountValidator' readable")
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
            let localised = NSLocalizedString(
                "is less than required minimum of %@ %@",
                comment: "'CountValidator' error message"
            )

            throw BasicValidationError(String(format: localised, "\(min)", element(for: min)))
        }

        guard collection.count <= max else {
            let localised = NSLocalizedString(
                "is greater than required maximum of %@ %@",
                comment: "'CountValidator' error message"
            )

            throw BasicValidationError(String(format: localised, "\(max)", element(for: max)))
        }
    }

    /// Get the correct `String` to print if a validation error is thrown.
    /// - parameter count: Count of element, allowing to defined if a type should note as plural.
    private func element(for count: Int) -> String {
        if T.Element.self is Character.Type {
            let character = NSLocalizedString(
                "character",
                comment: "Element display when 'CountValidator' is used on a string"
            )

            let characters = NSLocalizedString(
                "characters",
                comment: "Element display when 'CountValidator' is used on a string, plural"
            )

            return count == 1 ? character : characters
        } else {
            let item = NSLocalizedString(
                "item",
                comment: "Element display when 'CountValidator' is used on generic array"
            )

            let items = NSLocalizedString(
                "items",
                comment: "Element display when 'CountValidator' is used on generic array, plural"
            )

            return count == 1 ? item : items
        }
    }

}
