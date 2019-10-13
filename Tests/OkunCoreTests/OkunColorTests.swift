import XCTest
@testable import OkunCore

final class OkunColorTests: XCTestCase {
  func testColorRedEqual() {
    let color = OkunCore.Color.fromHexString("FF0000")
    XCTAssertEqual(color, .red)
  }
  
  func testColorGreenEqual() {
    let color = OkunCore.Color.fromHexString("00FF00")
    XCTAssertEqual(color, .green)
  }
  
  func testColorBlueEqual() {
    let color = OkunCore.Color.fromHexString("0000FF")
    XCTAssertEqual(color, .blue)
  }
  
  func testColorsAreNotEqual() {
    let color = OkunCore.Color.fromHexString("CC00E3")
    XCTAssertNotEqual(color, .black)
  }
  
  static var allTests = [
    ("testColorRedEqual", testColorRedEqual),
    ("testColorGreenEqual", testColorGreenEqual),
    ("testColorBlueEqual", testColorBlueEqual),
    ("testColorsAreNotEqual", testColorsAreNotEqual)
  ]
}

