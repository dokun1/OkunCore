import XCTest
@testable import OkunCore

final class OkunShapesTests: XCTestCase {
  func testCenterPointsEqual() {
    let center = OkunCore.Shapes.center(of: CGRect(x: 0, y: 0, width: 10, height: 10))
    XCTAssertEqual(CGPoint(x: 5, y: 5), center)
  }
  
  static var allTests = [
    ("testCenterPointsEqual", testCenterPointsEqual),
  ]
}

