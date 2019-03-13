//
//  URLValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T == String {

    /// Validate whether a `String` is a valid URL.
    ///
    /// This validator will allow either file URLs,
    /// or URLs containing at least a scheme and a host.
    public static var url: Validator<T> {
        return URLValidator().validator()
    }

}

/// Validate whether a `String` is a valid URL.
fileprivate struct URLValidator: ValidatorType {

    /// See `ValidatorType`.
    var readable = "url"

    /// See `ValidatorType`.
    func validate(_ url: String) throws {
        guard let url = URL(string: url), url.isFileURL || (url.host != nil && url.scheme != nil) else {
            throw BasicValidationError("isn't a valid URL")
        }
    }

}
