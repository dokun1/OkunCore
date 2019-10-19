import Foundation
import MapKit

protocol LocationManagerDelegate: class {
  func manager(_ id: UUID, didUpdateLocations locations: [CLLocation])
}

protocol LocationManagerInterface {
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
      var delegate: LocationManagerDelegate?
      private var currentLocationCallback: ((CLLocation) -> Void)?
      var id = UUID()
      
      /// Creates a new instance of  `Manager`, which sets up convenient location tracking for an iOS app.
      public override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
      }
      
      init(locationManagerMock: LocationManagerInterface) {
        self.locationManager = locationManagerMock
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
      }
      
      public func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        currentLocationCallback = { location in
          completion(location)
        }
        self.locationManager.requestLocation()
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
  var locationManagerDelegate: LocationManagerDelegate? {
    get { delegate as! LocationManagerDelegate? }
    set { delegate = newValue as! CLLocationManagerDelegate? }
  }
}
