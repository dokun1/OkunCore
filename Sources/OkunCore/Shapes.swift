import Foundation
import CoreGraphics

extension OkunCore {
  public class Shapes {
    
    /// Gets the center of a `CGRect` object in the format of a `CGPoint`.
    /// - Parameter rect: Fully instantiated `CGRect` instance.
    public static func center(of rect: CGRect) -> CGPoint {
      let x = rect.origin.x + (rect.size.width / 2)
      let y = rect.origin.y + (rect.size.height / 2)
      return CGPoint(x: x, y: y)
    }
  }
}
