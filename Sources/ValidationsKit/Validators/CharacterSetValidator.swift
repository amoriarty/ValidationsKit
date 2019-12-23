//
//  CharacterSetValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T == String {

    /// Validates that all characters in a `String` are ASCII (bytes 0..<128).
    public static var ascii: Validator<T> {
        return .characterSet(.ascii)
    }

    /// Validates that all characters in a `String` are alphanumeric (a-z,A-Z,0-9).
    public static var alphanumeric: Validator<T> {
        return .characterSet(.alphanumerics)
    }

    /// Validates that all characters in a `String` are in the supplied `CharacterSet`.
    public static func characterSet(_ set: CharacterSet) -> Validator<T> {
        return CharacterSetValidator(set).validator()
    }

}

/// Unions two character sets.
public func +(lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet {
    return lhs.union(rhs)
}


/// Validates that a `String` contains characters in a given `CharacterSet`
fileprivate struct CharacterSetValidator: ValidatorType {

    /// `CharacterSet` to validate against.
    let set: CharacterSet

    /// See `ValidatorType`.
    public var readable: String {
        guard set.traits.count > 0 else {
            return NSLocalizedString("in character set", comment: "'CharacterSetValidator' readable")
        }

        let readable = set.traits.joined(separator: ", ")
        let localised = NSLocalizedString("in character set (%@)", comment: "'CharacterSetValidator' readable")
        return String(format: localised, readable)
    }

    /// Creates a new `CharacterSetValidator`.
    init(_ set: CharacterSet) {
        self.set = set
    }

    /// See `ValidatorType`
    public func validate(_ s: String) throws {
        guard let range = s.rangeOfCharacter(from: set.inverted) else { return }
        let localised = NSLocalizedString(
            "contains an invalid character: '%@'",
            comment: "'CharacterSet' error message"
        )

        var reason = String(format: localised, "\(s[range])")
        guard set.traits.count > 0 else { throw BasicValidationError(reason) }
        let string = set.traits.joined(separator: ", ")
        let allowed = NSLocalizedString(
            " (allowed: %@)",
            comment: "'CharacterSet' error message"
        )

        reason += String(format: allowed, string)
        throw BasicValidationError(reason)
    }

}

extension CharacterSet {

    /// ASCII (byte 0..<128) character set.
    fileprivate static var ascii: CharacterSet {
        var ascii = CharacterSet()

        for i in 0..<128 {
            ascii.insert(Unicode.Scalar(i)!)
        }

        return ascii
    }

}


extension CharacterSet {

    /// Returns an array of strings describing the contents of this `CharacterSet`.
    fileprivate var traits: [String] {
        var desc: [String] = []
        if isSuperset(of: .capitalizedLetters) { desc.append("A-Z") }
        if isSuperset(of: .lowercaseLetters) { desc.append("a-z") }
        if isSuperset(of: .decimalDigits) { desc.append("0-9") }

        if isSuperset(of: .newlines) {
            desc.append(NSLocalizedString("newlines", comment: "'newlines' character set description"))
        }

        if isSuperset(of: .whitespaces) {
            desc.append(NSLocalizedString("whitespace", comment: "'whitespace' character set description"))
        }

        return desc
    }

}
