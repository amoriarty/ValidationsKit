//
//  MailValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

extension Validator where T == String {

    /// Validates whether a `String` is a valid mail address.
    public static var mail: Validator<T> {
        return MailValidator().validator()
    }

}

/// Validates whether a `String` is a valid mail address.
fileprivate struct MailValidator: ValidatorType {

    /// See `ValidatorType`.
    let readable = NSLocalizedString("mail address", comment: "'MailValidator' readable")

    func validate(_ mail: String) throws {
        guard let range = mail.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == mail.startIndex && range.upperBound == mail.endIndex else {
            throw BasicValidationError(
                NSLocalizedString("isn't a valid email address", comment: "'MailValidator' error message")
            )
        }
    }


    /// Create a new `MailValidator`.
    public init() {}
}
