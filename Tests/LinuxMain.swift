import XCTest

import ValidationTests

var tests = [XCTestCaseEntry]()
tests += ValidationTests.allTests()
XCTMain(tests)