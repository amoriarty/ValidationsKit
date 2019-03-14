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

    static func validations() throws -> Validations<UserModel> {
        var validations = Validations(UserModel.self)
        validations.add(\.mail, at: ["mail"], !.empty && .mail)
        validations.add(\.phone, at: ["phone"], .phone)
        validations.add(\.picture, at: ["picture"], .nil || .url)
        validations.add(\.ascii, at: ["ascii"], .ascii)
        validations.add(\.alphanumeric, at: ["alphanumeric"], .alphanumeric)
        validations.add(\.password, at: ["password"], .alphanumeric && .count(8...12))
        validations.add(\.delivery, at: ["delivery"], .in("short", "long"))
        validations.add(\.github, at: ["github"]) { link in
            guard !link.contains("https://github.com") else { return }
            throw BasicValidationError("isn't a valid GitHub link")
        }
        validations.add(\.twitter, at: ["twitter"]) { twitter in
            guard let twitter = twitter else { return }
            guard twitter.first != "@" else { return }
            throw BasicValidationError("isn't a valid Twitter username")
        }

        return validations
    }

}

final class ValidationTests: XCTestCase {
    private var user: UserModel!

    override func setUp() {
        user = UserModel(mail: "valid@example.com",
                  phone: "+33642424242",
                  picture: nil,
                  ascii: "someasciitext",
                  alphanumeric: "S0m3alphanum3rictext",
                  password: "somesuperpw",
                  delivery: "long",
                  github: "https://github.com/amoriarty",
                  twitter: "@twitter")
    }

    func testValidate() {
        do { try user.validate() }
        catch { XCTFail("valid mail return an error.") }
    }

    func testValidateMail() {
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
    }

    func testValidatePhone() {
        user.phone = "0989"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'phone' isn't a valid phone number")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
    }

    func testValidateUrl() {
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

    func testValidateAscii() {
        user.ascii = "😅"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'ascii' contains an invalid character: '😅'")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
    }

    func testValidateAlphanumrical() {
        user.alphanumeric = "😅"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'alphanumeric' contains an invalid character: '😅' (allowed: A-Z, a-z, 0-9)")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
    }

    func testValidateRange() {
        user.password = "short"
        do { try  user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'password' is less than required minimum of 8 characters")
        } catch {
            XCTFail("A non validation error as been thrown")
        }

        user.password = "awaytolongpassword"
        do { try  user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'password' is greater than required maximum of 12 characters")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
    }

    func testValidateIn() {
        user.delivery = "not in"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'delivery' isn't in short, long")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
    }

    func testCustomValidation() {
        user.github = "https://example.or"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'github' isn't a valid GitHub link")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
    }

    static var allTests = [
        ("testValidate", testValidate),
        ("testValidateMail", testValidateMail),
        ("testValidatePhone", testValidatePhone),
        ("testValidateUrl", testValidateUrl),
        ("testValidateAscii", testValidateAscii),
        ("testValidateAlphanumrical", testValidateAlphanumrical),
        ("testValidateRange", testValidateRange),
        ("testValidateIn", testValidateIn),
        ("testCustomValidation", testCustomValidation)
    ]
}
