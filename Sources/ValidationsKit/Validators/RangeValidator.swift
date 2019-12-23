//
//  RangeValidator.swift
//  ValidationsKit
//
//  Created by Alex Legent on 18/03/2019.
//

import Foundation

extension Validator where T: Comparable {

    /// Validates that the data is within the supplied `ClosedRange`.
    public static func range(_ range: ClosedRange<T>) -> Validator<T> {
        return RangeValidator(min: range.lowerBound, max: range.upperBound).validator()
    }

    /// Validates that the data is less than the supplied upper bound using `PartialRangeThrough`.
    public static func range(_ range: PartialRangeThrough<T>) -> Validator<T> {
        return RangeValidator(min: nil, max: range.upperBound).validator()
    }

    /// Validates that the data is less than the supplied lower bound using `PartialRangeFrom`.
    public static func range(_ range: PartialRangeFrom<T>) -> Validator<T> {
        return RangeValidator(min: range.lowerBound, max: nil).validator()
    }

}

extension Validator where T: Comparable & Strideable {

    /// Validates that the data is within the supplied `Range`.
    public static func range(_ range: Range<T>) -> Validator<T> {
        return RangeValidator(min: range.lowerBound, max: range.upperBound.advanced(by: -1)).validator()
    }

}

/// Validates whether the data is within a supplied int range.
fileprivate struct RangeValidator<T>: ValidatorType where T: Comparable {

    /// See `ValidatorType`.
    let readable = NSLocalizedString("range", comment: "'RangeValidator' readable")

    /// See `ValidatorType`.
    var validatorReadable: String {
        if let min = self.min, let max = self.max {
            let localised = NSLocalizedString("between %@ and %@", comment: "'RangeValidator' readable")
            return String(format: localised, "\(min)", "\(max)")
        } else if let min = self.min {
            let localised = NSLocalizedString("at least %@", comment: "'RangeValidator' readable")
            return String(format: localised, "\(min)")
        } else if let max = self.max {
            let localised = NSLocalizedString("at most %@", comment: "'RangeValidator' readable")
            return String(format: localised, "\(max)")
        }
        return "valid"
    }

    /// Minimum inclusive possible value, not checked if nil.
    let min: T?

    /// Maximum inclusive possible value, not checked if nil.
    let max: T?

    /// Create a range validator using a partial range from
    init(min: T?, max: T?) {
        self.min = min
        self.max = max
    }

    /// See `ValidatorType`.
    func validate(_ data: T) throws {
        if let min = self.min {
            guard data >= min else {
                let localised = NSLocalizedString("is less than %@", comment: "'RangeValidator' error message")
                throw BasicValidationError(String(format: localised, "\(min)"))
            }
        }

        if let max = self.max {
            guard data <= max else {
                let localised = NSLocalizedString("is greater than %@", comment: "'RangeValidator' error message")
                throw BasicValidationError(String(format: localised, "\(max)"))
            }
        }
    }

}
