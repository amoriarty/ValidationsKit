import XCTest
@testable import Validation

struct TestModel: Validatable {
    var mail: String
    var phone: String
    var picture: String?
    var ascii: String
    var alphanumeric: String

    static func validations() throws -> Validations<TestModel> {
        var validations = Validations(TestModel.self)
        validations.add(\.mail, at: ["mail"], !.empty && .mail)
        validations.add(\.phone, at: ["phone"], .phone)
        validations.add(\.picture, at: ["picture"], .nil || .url)
        validations.add(\.ascii, at: ["ascii"], .ascii)
        validations.add(\.alphanumeric, at: ["alphanumeric"], .alphanumeric)
        return validations
    }

}

final class ValidationTests: XCTestCase {

    func testValidate() {
        var user = TestModel(mail: "valid@example.com",
                        phone: "+33642424242",
                        picture: nil,
                        ascii: "someasciitext",
                        alphanumeric: "S0m3alphanum3rictext")

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

        user.ascii = "😅"
        user.picture = "https://example.com"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'ascii' contains an invalid character: '😅'")
        } catch {
            XCTFail("A non validation error as been thrown")
        }

        user.ascii = "valid"
        user.alphanumeric = "😅"
        do { try user.validate() }
        catch let error as ValidationError {
            XCTAssertEqual("\(error)", "'alphanumeric' contains an invalid character: '😅' (allowed: A-Z, a-z, 0-9)")
        } catch {
            XCTFail("A non validation error as been thrown")
        }
        
    }

    static var allTests = [
        ("testValidate", testValidate),
    ]
}
