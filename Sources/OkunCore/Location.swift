import Foundation
import MapKit

public protocol LocationManagerDelegate: class {
  func manager(_ id: UUID, didReceiveFirst location: CLLocationCoordinate2D)
}

extension OkunCore {
  public struct Location {
    public class Manager: NSObject, CLLocationManagerDelegate {
      private var locationManager: CLLocationManager?
      public var lastLoggedLocation: CLLocation?
      public var delegate: LocationManagerDelegate?
      var id = UUID()
      
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
            delegate?.manager(self.id, didReceiveFirst: location.coordinate)
          }
        }
      }
    }
  }
}
