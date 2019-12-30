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

        var isValid: Bool {
            !mail.isEmpty
        }

        static func validations() throws -> Validations<Contact> {
            var validations = Validations(Contact.self)

            validations.add(\.mail, at: ["mail"], withModel: { contact in
                guard !contact.isValid else { return }
                throw BasicValidationError("shouldn't be empty")
            })

            return validations
        }
    }

    func testValidationFromModel() {
        XCTAssertNoThrow(try Contact(mail: "user@mail.com").validate())
        XCTAssertThrowsError(try Contact(mail: "").validate()) { error in
            XCTAssertEqual("\(error)", "'mail' shouldn't be empty")
        }

    }

}
