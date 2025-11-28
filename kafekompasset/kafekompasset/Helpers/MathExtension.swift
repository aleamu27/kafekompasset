import Foundation
import CoreLocation

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}

extension CLLocationCoordinate2D {
    // Beregner retning (bearing) fra self (bruker) til destination (kafe) i grader
    func bearing(to destination: CLLocationCoordinate2D) -> Double {
        let lat1 = self.latitude.degreesToRadians
        let lon1 = self.longitude.degreesToRadians
        
        let lat2 = destination.latitude.degreesToRadians
        let lon2 = destination.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let radiansBearing = atan2(y, x)
        
        // Konverter til grader (0-360)
        return (radiansBearing.radiansToDegrees + 360).truncatingRemainder(dividingBy: 360)
    }
}
