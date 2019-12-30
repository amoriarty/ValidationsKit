//
//  ValidationFromModelTests.swift
//  ValidationsKit
//
//  Created by Alexandre Legent on 30/12/2019.
//

import Foundation
import XCTest
@testable import ValidationsKit

final class ValidationFromModelTests: XCTestCase {

    static let allTests = [
        ("testValidationFromModel", testValidationFromModel)
    ]

    struct Contact: Codable, Reflectable, Validatable {
        let mail: String
        let message: String

        var isValidMail: Bool {
            !mail.isEmpty
        }

        static func validations() throws -> Validations<Contact> {
            var validations = Validations(Contact.self)

            validations.add(\.mail, at: ["mail"], withModel: { contact in
                guard !contact.isValidMail else { return }
                throw BasicValidationError("shouldn't be empty")
            })

            try validations.add(\.message, withModel: { contact in
                guard contact.message.isEmpty else { return }
                throw BasicValidationError("")
            }, message: { "message '\($0)' shouldn't be empty" })

            return validations
        }
    }

    func testValidationFromModel() {
        XCTAssertNoThrow(try Contact(mail: "user@mail.com", message: "some message").validate())
        XCTAssertThrowsError(try Contact(mail: "", message: "some message").validate()) { error in
            XCTAssertEqual("\(error)", "'mail' shouldn't be empty")
        }

        XCTAssertThrowsError(try Contact(mail: "user@mail.com", message: "").validate()) { error in
            XCTAssertEqual("\(error)", "message '' shouldn't be empty")
        }
    }

}
