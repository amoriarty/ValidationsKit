import XCTest
@testable import Validation

struct User: Validatable {
    var mail: String

    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        validations.add(\.mail, at: ["mail"], .mail)
        return validations
    }

}

final class ValidationTests: XCTestCase {

    func testValidate() {
        var user = User(mail: "valid@example.com")

        do { try user.validate() }
        catch { XCTFail("valid mail return an error.") }

        user.mail = "invalid_mail"
        do { try user.validate() }
        catch {
            XCTAssertNotNil(error as? ValidationError, "invalid mail should throw a ValidationError")
            XCTAssertEqual("\(error)", "'mail' is not a valid email address")
        }
    }

    static var allTests = [
        ("testValidate", testValidate),
    ]
}
