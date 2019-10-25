import Foundation

protocol NetworkSession {
  func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
  func sendData(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
  func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
    let task = dataTask(with: url) { data, _, error in
      completionHandler(data, error)
    }
    task.resume()
  }
  
  func sendData(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
    let task = dataTask(with: request) { data, _, error in
      completionHandler(data, error)
    }
    task.resume()
  }
}

extension OkunCore {
  public struct Networking {
    public class Manager {
      private let session: NetworkSession
      
      init(session: NetworkSession = URLSession.shared) {
        self.session = session
      }
      
      public init() {
        self.session = URLSession.shared
      }
      
      public func post<I: Codable>(to url: URL, body: I, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
        var request = URLRequest(url: url)
        do {
          let body = try JSONEncoder().encode(body)
          request.httpBody = body
          request.httpMethod = "POST"
          session.sendData(with: request) { data, error in
            let result = data.map(NetworkResult<Data>.success) ?? .failure(error!)
            completionHandler(result)
          }
        } catch let error {
          return completionHandler(.failure(error))
        }
      }
      
      public func get(from url: URL, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
        session.loadData(from: url) { data, error in
          let result = data.map(NetworkResult<Data>.success) ?? .failure(error!)
          completionHandler(result)
        }
      }
    }
  
    public enum NetworkResult<Value> {
      case success(Value)
      case failure(Error)
    }
  }
}
