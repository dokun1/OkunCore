import XCTest
import MapKit
@testable import OkunCore

final class LocationTestDelegate: LocationManagerDelegate {
  var expectation: XCTestExpectation?
  var result = false
  
  func manager(_ id: UUID, didReceive location: CLLocationCoordinate2D) {
    print("location: \(location)")
    guard let expectation = expectation else {
      XCTFail("Expectation not correctly set")
      return
    }
    result = true
    expectation.fulfill()
  }
}

final class OkunLocationTests: XCTestCase {
  func testManagerExists() {
    let manager = OkunCore.Location.Manager()
    XCTAssertNotNil(manager, "Manager should exist and not be nil")
    XCTAssertNotNil(manager.id, "Manager id should not be nil")
  }
  
  func testUniqueManagers() {
    let manager1 = OkunCore.Location.Manager()
    let manager2 = OkunCore.Location.Manager()
    XCTAssertNotEqual(manager1.id, manager2.id, "Two discretely created managers should have unique IDs")
  }
  
  func testManagerLogsLocation() {
    let delegate = LocationTestDelegate()
    let expectation = XCTestExpectation(description: "Location is reported fully by a location manager.")
    delegate.expectation = expectation
    let manager = OkunCore.Location.Manager()
    manager.delegate = delegate
    
    waitForExpectations(timeout: 5) { error in
      if let error = error {
        XCTFail("Error occurred: \(error.localizedDescription)")
      }
      XCTAssertTrue(delegate.result, "Result was never changed because location was never reported.")
    }
  }
  
  static var allTests = [
    ("testManagerExists", testManagerExists),
    ("testUniqueManagers", testUniqueManagers),
    ("testManagerLogsLocation", testManagerLogsLocation)
  ]
}

