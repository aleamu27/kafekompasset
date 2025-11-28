import Foundation
import CoreLocation

struct Cafe: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
