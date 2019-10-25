import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(OkunColorTests.allTests),
    testCase(OkunShapesTests.allTests),
    testCase(OkunNetworkingTests.allTests)
  ]
}
#endif

