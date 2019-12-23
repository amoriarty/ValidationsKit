import XCTest
@testable import ValidationsKit

struct UserModel: Validatable {
    var mail: String
    var phone: String
    var picture: String?
    var ascii: String
    var alphanumeric: String
    var password: String
    var delivery: String
    var github: String
    var twitter: String?
    var customMessage: String
    var noValidator: String?

    static func validations() throws -> Validations<UserModel> {
        var validations = Validations(UserModel.self)
        validations.add(\.mail, at: ["mail"], !.empty && .mail)
        validations.add(\.phone, at: ["phone"], .phone)
        validations.add(\.picture, at: ["picture"], .nil || .url)
        validations.add(\.ascii, at: ["ascii"], .ascii)
        validations.add(\.alphanumeric, at: ["alphanumeric"], .alphanumeric)
        validations.add(\.password, at: ["password"], .alphanumeric && .count(8...12))
        validations.add(\.delivery, at: ["delivery"], .in("short", "long"))
        validations.add(\.github, at: ["github"], validator: { link in
            guard !link.contains("https://github.com") else { return }
            throw BasicValidationError("isn't a valid GitHub link")
        })
        validations.add(\.twitter, at: ["twitter"], validator: { twitter in
            guard let twitter = twitter else { return }
            guard twitter.first != "@" else { return }
            throw BasicValidationError("isn't a valid Twitter username")
        })

        validations.add(\.customMessage, at: ["customMessage"], !.empty) { customMessage in
            return "this custom error message should appear instead of the auto generated one"
        }

        return validations
    }

}

final class ValidationsKitTests: XCTestCase {
    private var user: UserModel!

    static let allTests = [
        ("testValidate", testValidate),
        ("testSingleFieldValidate", testSingleFieldValidate),
        ("testCustomValidation", testCustomValidation)
    ]

    override func setUp() {
        user = UserModel(
            mail: "valid@example.com",
            phone: "+33642424242",
            picture: nil,
            ascii: "someasciitext",
            alphanumeric: "S0m3alphanum3rictext",
            password: "somesuperpw",
            delivery: "long",
            github: "https://github.com/amoriarty",
            twitter: "@twitter",
            customMessage: "some placeholder",
            noValidator: nil
        )
    }

    func testValidate() {
        XCTAssertNoThrow(try user.validate())
    }

    func testSingleFieldValidate() {
        user.phone = ""
        XCTAssertNoThrow(try user.validate(at: \UserModel.mail))
        XCTAssertThrowsError(try user.validate(at: \UserModel.phone)) { error in
            XCTAssertEqual("\(error)", "'phone' isn't a valid phone number")
        }

        XCTAssertThrowsError(try user.validate(at: \UserModel.noValidator)) { error in
            XCTAssertNotNil(error as? UndefinedValidationError)
        }
    }

    func testCustomValidation() {
        user.github = "https://example.or"
        XCTAssertThrowsError(try user.validate()) { error in
            XCTAssertEqual("\(error)", "'github' isn't a valid GitHub link")
        }
    }

    func testCustomErrorMessage() {
        user.customMessage = ""
        XCTAssertThrowsError(try user.validate(at: \UserModel.customMessage)) { error in
            XCTAssertNotNil(error as? CustomValidationError)
            XCTAssertEqual("\(error)", "this custom error message should appear instead of the auto generated one")
        }
    }

}
