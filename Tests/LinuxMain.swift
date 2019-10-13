import XCTest

import OkunColorTests

var tests = [XCTestCaseEntry]()
tests += OkunColorTests.allTests()
tests += OkunShapesTests.allTests()
XCTMain(tests)
