//
//  ValidatorsTests.swift
//  ValidationsKitTests
//
//  Created by Alex Legent on 17/03/2019.
//

import XCTest
@testable import ValidationsKit

final class ValidatorsTests: XCTestCase {

    static let allTests = [
        ("testMailValidator", testMailValidator),
        ("testPhoneValidator", testPhoneValidator),
        ("testCountCharactersValidator", testCountCharactersValidator),
        ("testCountItemsValidator", testCountItemsValidator),
        ("testUrlValidator", testUrlValidator),
        ("testASCIIValidator", testASCIIValidator),
        ("testAlphanumericValidator", testAlphanumericValidator),
        ("testEmptyValidator", testEmptyValidator),
        ("testInValidator", testInValidator),
        ("testRangeValidator", testRangeValidator)
    ]

    func testMailValidator() {
        XCTAssertNoThrow(try Validator<String>.mail.validate("tanner@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.mail.validate("tanner@vapor.codestanner@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.mail.validate("tanner@vapor.codes."))
        XCTAssertThrowsError(try Validator<String>.mail.validate("tanner@@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.mail.validate("@vapor.codes"))
        XCTAssertThrowsError(try Validator<String>.mail.validate("tanner@codes"))
        XCTAssertThrowsError(try Validator<String>.mail.validate("asdf"))
    }

    func testPhoneValidator() {
        XCTAssertNoThrow(try Validator<String>.phone.validate("+33642424242"))
        XCTAssertThrowsError(try Validator<String>.phone.validate("42")) { error in
            XCTAssertEqual("\(error)", "data isn't a valid phone number")
        }
    }

    func testCountCharactersValidator() {
        let validator = Validator<String>.count(1...6)
        XCTAssertNoThrow(try validator.validate("1"))
        XCTAssertNoThrow(try validator.validate("123"))
        XCTAssertNoThrow(try validator.validate("123456"))
        XCTAssertThrowsError(try validator.validate("")) { error in
            XCTAssertEqual("\(error)", "data is less than required minimum of 1 character")
        }
        XCTAssertThrowsError(try validator.validate("1234567")) { error in
            XCTAssertEqual("\(error)", "data is greater than required maximum of 6 characters")
        }
    }

    func testCountItemsValidator() {
        let validator = Validator<[Int]>.count(1...6)
        XCTAssertNoThrow(try validator.validate([1]))
        XCTAssertNoThrow(try validator.validate([1, 2, 3]))
        XCTAssertNoThrow(try validator.validate([1, 2, 3, 4, 5, 6]))
        XCTAssertThrowsError(try validator.validate([])) { error in
            XCTAssertEqual("\(error)", "data is less than required minimum of 1 item")
        }
        XCTAssertThrowsError(try validator.validate([1, 2, 3, 4, 5, 6, 7])) { error in
            XCTAssertEqual("\(error)", "data is greater than required maximum of 6 items")
        }
    }

    func testUrlValidator() {
        XCTAssertNoThrow(try Validator<String>.url.validate("https://www.somedomain.com/somepath.png"))
        XCTAssertNoThrow(try Validator<String>.url.validate("https://www.somedomain.com/"))
        XCTAssertNoThrow(try Validator<String>.url.validate("file:///Users/vapor/rocks/somePath.png"))
        XCTAssertThrowsError(try Validator<String>.url.validate("www.somedomain.com/"))
        XCTAssertThrowsError(try Validator<String>.url.validate("bananas"))
    }

    func testASCIIValidator() {
        XCTAssertNoThrow(
            try Validator<String>.ascii.validate("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        )
        XCTAssertNoThrow(try Validator<String>.ascii.validate("\n\r\t"))
        XCTAssertNoThrow(try Validator<String>.ascii.validate(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"))
        XCTAssertThrowsError(try Validator<String>.ascii.validate("\n\r\t\u{129}"))
        XCTAssertThrowsError(
            try Validator<String>.ascii.validate("ABCDEFGHIJKLMNOPQR🤠STUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
        )
    }

    func testAlphanumericValidator() {
        XCTAssertNoThrow(
            try Validator<String>
                .alphanumeric
                .validate("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        )
        XCTAssertThrowsError(
            try Validator<String>
                .alphanumeric
                .validate("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
        )
    }

    func testEmptyValidator() {
        XCTAssertNoThrow(try Validator<String>.empty.validate(""))
        XCTAssertNoThrow(try Validator<[Int]>.empty.validate([]))
        XCTAssertThrowsError(try Validator<String>.empty.validate("something"))
        XCTAssertThrowsError(try Validator<[Int]>.empty.validate([1, 2]))
    }

    func testInValidator() {
        XCTAssertNoThrow(try Validator<String>.in("short", "long").validate("short"))
        XCTAssertNoThrow(try Validator<String>.in("short", "long").validate("long"))
        XCTAssertThrowsError(try Validator<String>.in("short", "long").validate("not in")) { error in
            XCTAssertEqual("\(error)", "data isn't in short, long")
        }
    }

    func testRangeValidator() {
        XCTAssertNoThrow(try Validator<Int>.range(-5...5).validate(4))
        XCTAssertNoThrow(try Validator<Int>.range(-5...5).validate(5))
        XCTAssertNoThrow(try Validator<Int>.range(-5...5).validate(-5))
        XCTAssertNoThrow(try Validator<Int>.range(5...).validate(.max))
        XCTAssertNoThrow(try Validator<Int>.range(-5..<6).validate(-5))
        XCTAssertNoThrow(try Validator<Int>.range(-5..<6).validate(-4))
        XCTAssertNoThrow(try Validator<Int>.range(-5..<6).validate(5))

        XCTAssertThrowsError(try Validator<Int>.range(-5..<6).validate(-6))
        XCTAssertThrowsError(try Validator<Int>.range(-5..<6).validate(6))

        XCTAssertThrowsError(try Validator<Int>.range(-5...5).validate(6)) { error in
            XCTAssertEqual("\(error)", "data is greater than 5")
        }
        XCTAssertThrowsError(try Validator<Int>.range(-5...5).validate(-6)) { error in
            XCTAssertEqual("\(error)", "data is less than -5")
        }
    }

}
