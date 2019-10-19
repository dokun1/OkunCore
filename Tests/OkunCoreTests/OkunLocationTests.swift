import XCTest
import MapKit
@testable import OkunCore

struct LocationManagerMock: LocationManagerInterface {
  func requestWhenInUseAuthorization() {
    print("requested")
  }
  
  var locationManagerDelegate: LocationManagerDelegate?
  var desiredAccuracy: CLLocationAccuracy = 0
  var locationToReturn: (() -> CLLocation)?
  
  func requestLocation() {
    guard let location = locationToReturn?() else {
      return
    }
    locationManagerDelegate?.manager(UUID(), didUpdateLocations: [location])
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
    var mock = LocationManagerMock()
    mock.locationToReturn = {
      return CLLocation(latitude: 10.0, longitude: 10.0)
    }
    mock.locationManagerDelegate = self
    let manager = OkunCore.Location.Manager(locationManagerMock: mock)
    
    let expectedLocation = CLLocation(latitude: 10.0, longitude: 10.0)
    let expectation = XCTestExpectation(description: "strings are equal")
    
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

extension OkunLocationTests: LocationManagerDelegate {
  func manager(_ id: UUID, didUpdateLocations locations: [CLLocation]) {
    print("something")
  }
  
  
}

