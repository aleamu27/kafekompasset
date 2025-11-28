import Foundation
import CoreLocation
import Combine
import OSLog // <--- Import

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var userHeading: CLHeading?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        Logger.location.info("📡 Spør om GPS-tillatelse...")
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        // Debug-logging (vises kun hvis du filtrerer på det, så det ikke spammer)
        Logger.location.debug("📍 Posisjon: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.userHeading = newHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Her bruker vi .fault fordi dette er kritisk
        Logger.location.fault("🛑 GPS FEIL: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                Logger.location.error("⚠️ Location Unknown (Prøv å bytte by i Xcode simulator!)")
            case .denied:
                Logger.location.error("🚫 Bruker nektet GPS-tilgang")
            default:
                Logger.location.error("⚠️ Annen GPS feil: \(clError.code.rawValue)")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            Logger.location.notice("✅ GPS Tillatelse gitt!")
        case .denied, .restricted:
            Logger.location.fault("🚫 GPS Tillatelse nektet!")
        case .notDetermined:
            Logger.location.info("⏳ Venter på svar fra bruker...")
        @unknown default:
            break
        }
    }
}
