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
  
  func sendData(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
    completionHandler(data, error)
  }
}

struct MockData: Codable, Equatable {
  var id: Int
  var name: String
}

final class OkunNetworkingTests: XCTestCase {
  func testGetCall() {
    let session = NetworkSessionMock()
    let manager = OkunCore.Networking.Manager(session: session)
    
    let data = Data([0, 1, 0, 1])
    session.data = data
    let url = URL(fileURLWithPath: "url")
    
    let expectation = XCTestExpectation(description: "Called for data")
    manager.get(from: url) { result in
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
  
  func testPostCall() {
    let session = NetworkSessionMock()
    let manager = OkunCore.Networking.Manager(session: session)
    
    let payload = MockData(id: 1, name: "David")
    session.data = try? JSONEncoder().encode(payload)
    let url = URL(fileURLWithPath: "url")
    
    let expectation = XCTestExpectation(description: "Called for sent data")
    manager.post(to: url, body: payload) { result in
      expectation.fulfill()
      switch result {
      case .success(let returnedData):
        let returnedPayload = try? JSONDecoder().decode(MockData.self, from: returnedData)
        XCTAssertEqual(returnedPayload, payload)
        break
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    }
    wait(for: [expectation], timeout: 5)
  }
  
  static var allTests = [
    ("testGetCall", testGetCall),
    ("testPostCall", testPostCall)
  ]
}
