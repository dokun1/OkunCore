import Foundation
import MapKit

protocol LocationManagerDelegate: class {
  func manager(_ manager: OkunCore.Location.Manager, didUpdateLocations locations: [CLLocation])
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
    public class Manager: NSObject, LocationManagerDelegate {
      private var locationManager: LocationManagerInterface
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

      func manager(_ manager: OkunCore.Location.Manager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
          return
        }
        if let callback = currentLocationCallback {
          callback(location)
        }
        self.currentLocationCallback = nil
      }
    }
  }
}

extension OkunCore.Location.Manager: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.manager(self.locationManager as! OkunCore.Location.Manager, didUpdateLocations: locations)
  }
}

extension CLLocationManager: LocationManagerInterface {
  var locationManagerDelegate: LocationManagerDelegate? {
    get {
      return delegate as! LocationManagerDelegate?
    }
    set {
      delegate = newValue as! CLLocationManagerDelegate?
    }
  }
}
