import XCTest

@testable import OkunCore

class URLSessionDataTaskMock: URLSessionDataTask {
  private let closure: () -> Void
  
  init(closure: @escaping () -> Void) {
    self.closure = closure
  }
  
  override func resume() {
    closure()
  }
}

class NetworkSessionMock: NetworkSession {
  var data: Data?
  var error: Error?
  
  func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
    completionHandler(data, error)
  }
}

final class OkunNetworkingTests: XCTestCase {
  func testNetworkingCall() {
    let session = NetworkSessionMock()
    let manager = OkunCore.Networking.Manager(session: session)
    
    let data = Data([0, 1, 0, 1])
    session.data = data
    let url = URL(fileURLWithPath: "url")
    
    let expectation = XCTestExpectation(description: "Called for data")
    manager.loadData(from: url) { result in
      expectation.fulfill()
      switch result {
      case .success(let returnedData):
        XCTAssertEqual(data, returnedData)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    }
    wait(for: [expectation], timeout: 5)
  }
  
  static var allTests = [
    ("testNetworkingCall", testNetworkingCall)
  ]
}
