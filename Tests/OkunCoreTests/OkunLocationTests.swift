import XCTest
import MapKit
import OkunCore
@testable import OkunCore

var mock = LocationManagerMock()
let manager = OkunCore.Location.Manager(locationManagerMock: mock)

struct LocationManagerMock: LocationManagerInterface {
  var locationManagerDelegate: LocationManagerDelegate?
  
  func requestWhenInUseAuthorization() {
    print("requested when in use authorization")
  }
  
  var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
  var locationToReturn = {
    return CLLocation(latitude: 10.0, longitude: 10.0)
  }
  
  func requestLocation() {
    manager.manager(manager, didUpdateLocations: [locationToReturn()])
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
  
  func testNewManagerLogsLocation() {
    let mock = LocationManagerMock()

    let manager = OkunCore.Location.Manager(locationManagerMock: mock)
    let expectedLocation = CLLocation(latitude: 10.0, longitude: 10.0)
    let expectation = XCTestExpectation(description: "location was returned.")
    
    manager.getCurrentLocation { location in
      expectation.fulfill()
      XCTAssertEqual(location.coordinate.latitude, expectedLocation.coordinate.latitude, "latitudes should be equal")
      XCTAssertEqual(location.coordinate.longitude, expectedLocation.coordinate.longitude, "longitude should be equal")
    }
    wait(for: [expectation], timeout: 5)
  }
  
  static var allTests = [
    ("testManagerExists", testManagerExists),
    ("testUniqueManagers", testUniqueManagers),
    ("testNewManagerLogsLocation", testNewManagerLogsLocation)
  ]
}
