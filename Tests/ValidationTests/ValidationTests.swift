import XCTest
@testable import Validation

struct User: Validatable {
    var mail: String
    var phone: String
    var picture: String?

    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        validations.add(\.mail, at: ["mail"], !.empty && .mail)
        validations.add(\.phone, at: ["phone"], .phone)
        validations.add(\.picture, at: ["picture"], .nil || .url)
        return validations
    }

}

final class ValidationTests: XCTestCase {

    func testValidate() {
        var user = User(mail: "valid@example.com",
                        phone: "+33642424242",
                        picture: nil)

        do { try user.validate() }
        catch { XCTFail("valid mail return an error.") }

        user.mail = "invalid_mail"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'mail' isn't a valid email address")
        } catch {
            XCTFail("A non validation error as been thrown")
        }

        user.mail = ""
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'mail' is empty")
        } catch {
            XCTFail("A non validation error as been thrown")
        }

        user.mail = "valid@example.com"
        user.phone = "0989"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'phone' isn't a valid phone number")
        } catch {
            XCTFail("A non validation error as been thrown")
        }

        user.phone = "+33642424242"
        user.picture = "https://example.com"
        do { try user.validate() }
        catch { XCTFail("valid url return an error.") }

        user.picture = "not_an_url"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'picture' isn't nil or 'picture' isn't a valid URL")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
        
    }

    static var allTests = [
        ("testValidate", testValidate),
    ]
}
