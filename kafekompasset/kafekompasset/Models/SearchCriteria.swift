import Foundation
import CoreLocation

// 1. Dette sender vi TIL serveren (Filtrering)
struct SearchRequest: Encodable {
    let latitude: Double
    let longitude: Double
    let minRating: Double
    let openNow: Bool
    let requiredFeatures: [String] // F.eks ["outdoor_seating", "wifi"]
}

// 2. Dette får vi FRA serveren (Resultatet)
struct CafeResponse: Decodable {
    let found: Bool
    let name: String
    let latitude: Double
    let longitude: Double
    let isOpen: Bool
    let rating: Double?
    let userRatingsTotal: Int?
    let priceLevel: String?    // F.eks "Middels", "Billig"
    let features: [String]?    // F.eks ["Uteservering ☀️", "Vegetar 🥬"]
    
    // En hjelper for å få kart-koordinater
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// 3. UI-hjelper: Hva brukeren har valgt i menyen
struct SearchCriteria {
    var mustBeOpen: Bool = true
    var wantsOutdoor: Bool = false
    var wantsVegetarian: Bool = false
    var wantsWifi: Bool = false
    var minRating: Double = 0.0
}
