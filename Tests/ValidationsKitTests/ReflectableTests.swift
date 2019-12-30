//
//  ReflectableTests.swift
//  ValidationsKit
//
//  Created by Alexandre Legent on 24/12/2019.
//

import Foundation
import XCTest
@testable import ValidationsKit

final class ReflectableTests: XCTestCase {

    static let allTests = [
        ("testReflectable", testReflectable),
        ("testReflectableWithError", testReflectableWithError),
        ("testReflectableWithCustomError", testReflectableWithCustomError),
        ("testReflectableWithCustomValidator", testReflectableWithCustomValidator)
    ]

    struct User: Codable, Reflectable, Validatable {
        let username: String
        let password: String
        let twitter: String
        let message: String

        static func validations() throws -> Validations<ReflectableTests.User> {
            var validations = Validations(User.self)
            try validations.add(\.username, !.empty)
            try validations.add(\.password, .count(8...))

            try validations.add(\.twitter, validator: { twitter in
                guard !twitter.hasPrefix("@") else { return }
                throw BasicValidationError("")
            }, message: { _ in "Twitter username should start with '@'" })

            try validations.add(\.message, .count(8 ..< 12)) { message in
                "Your message: '\(message)' isn't nil or between 8 and 12 characters"
            }

            return validations
        }
    }

    func testReflectable() {
        let user = User(username: "username", password: "password1234", twitter: "@user", message: "somemessage")
        XCTAssertNoThrow(try user.validate())
    }

    func testReflectableWithError() {
        let username = User(username: "", password: "password1234", twitter: "@user", message: "somemessage")

        XCTAssertThrowsError(try username.validate()) { error in
            XCTAssertEqual("\(error)", "'username' is empty")
        }

        let password = User(username: "username", password: "pwd", twitter: "@user", message: "somemessage")

        XCTAssertThrowsError(try password.validate()) { error in
            XCTAssertEqual("\(error)", "'password' is less than required minimum of 8 characters")
        }
    }

    func testReflectableWithCustomError() {
        let user = User(username: "username", password: "password1234", twitter: "@user", message: "")

        XCTAssertThrowsError(try user.validate()) { error in
            XCTAssertEqual("\(error)", "Your message: '' isn't nil or between 8 and 12 characters")
        }
    }

    func testReflectableWithCustomValidator() {
        let user = User(username: "username", password: "password1234", twitter: "user", message: "somemessage")

        XCTAssertThrowsError(try user.validate()) { error in
            XCTAssertEqual("\(error)", "Twitter username should start with '@'")
        }
    }

}
