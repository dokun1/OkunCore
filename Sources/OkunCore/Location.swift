import Foundation
import MapKit

public protocol LocationManagerDelegate {
  
  /// Called whenever the `Manager` instance receives a location update.
  /// Note: Probably should upgrade this to use Combine with a subscriber method.
  /// - Parameter id: The `UUID` of the relevant `Manager`.
  /// - Parameter location: The location logged by the `manager` instance, in `CLLocationCoordinate2D` format.
  func manager(_ id: UUID, didReceive location: CLLocationCoordinate2D)
}

extension OkunCore {
  public struct Location {
    
    /// Returns a consistent location for ease of tracking user location in iOS app.
    public class Manager: NSObject, CLLocationManagerDelegate {
      private var locationManager: CLLocationManager?
      public var lastLoggedLocation: CLLocation?
      public var delegate: LocationManagerDelegate?
      var id = UUID()
      
      
      /// Creates a new instance of  `Manager`, which sets up convenient location tracking for an iOS app.
      public override init() {
        super.init()
        self.locationManager = CLLocationManager()
        if let manager = self.locationManager {
          manager.requestWhenInUseAuthorization()
          if CLLocationManager.locationServicesEnabled() {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            lastLoggedLocation = nil
            manager.startUpdatingLocation()
          }
        }
      }
      
      public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
          defer {
            self.lastLoggedLocation = location
          }
          if self.lastLoggedLocation == nil {
            self.lastLoggedLocation = location
            delegate?.manager(self.id, didReceive: location.coordinate)
          }
        }
      }
    }
  }
}
