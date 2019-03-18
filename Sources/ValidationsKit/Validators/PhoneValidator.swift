//
//  PhoneValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T == String {

    /// Validates whether a `String` is a valid phone number.
    static var phone: Validator<T> {
        return PhoneValidator().validator()
    }
}

/// Validates whether a `String` is a valid phone number.
fileprivate struct PhoneValidator: ValidatorType {

    /// See `ValidatorType`.
    let readable = "phone"

    /// See `ValidatorType`.
    func validate(_ phone: String) throws {
        guard let range = phone.range(of: "^\\+\\d{11}$", options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == phone.startIndex && range.upperBound == phone.endIndex else {
            throw BasicValidationError("isn't a valid phone number")
        }
    }
    
}
