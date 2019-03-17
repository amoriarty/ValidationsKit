import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ValidationsKitTests.allTests),
        testCase(ValidatorsTests.allTests),
    ]
}
#endif
