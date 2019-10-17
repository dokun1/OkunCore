import Foundation
import MapKit

public protocol LocationManagerDelegate: class {
  func manager(_ id: UUID, didUpdateLocations locations: [CLLocation])
}

public protocol LocationManagerInterface {
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestLocation()
    func requestWhenInUseAuthorization()
}

extension OkunCore {
  public struct Location {
    
    /// Returns a consistent location for ease of tracking user location in iOS app.
    public class Manager: NSObject, LocationManagerDelegate, CLLocationManagerDelegate {
      private var locationManager: LocationManagerInterface
      public var delegate: LocationManagerDelegate?
      private var currentLocationCallback: ((CLLocation) -> Void)?
      var id = UUID()
      
      public func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        currentLocationCallback = { location in
          completion(location)
        }
      }
      
      /// Creates a new instance of  `Manager`, which sets up convenient location tracking for an iOS app.
      public init(locationManager: LocationManagerInterface = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
      }
      
      public func manager(_ id: UUID, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
          return
        }
        self.currentLocationCallback?(location)
        self.currentLocationCallback = nil
      }
      
      public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager(self.id, didUpdateLocations: locations)
      }
    }
  }
}

extension CLLocationManager: LocationManagerInterface {
  public var locationManagerDelegate: LocationManagerDelegate? {
    get { delegate as! LocationManagerDelegate? }
    set { delegate = newValue as! CLLocationManagerDelegate? }
  }
}
