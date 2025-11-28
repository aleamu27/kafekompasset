import Foundation
import CoreLocation
import SwiftUI
import Combine

class CompassViewModel: ObservableObject {
    @Published var needleRotation: Double = 0
    @Published var distanceToCafe: String = "0 meter"
    @Published var currentCafe: CafeResponse?
    @Published var filters = SearchCriteria() // Her lagres filtervalgene
    
    private let locationService = LocationService()
    private let cafeService = CafeService()
    private var lastKnownLocation: CLLocation?
    
    init() {
        locationService.$userLocation.combineLatest(locationService.$userHeading)
            .compactMap { location, heading -> (CLLocation, CLHeading)? in
                guard let loc = location, let head = heading else { return nil }
                return (loc, head)
            }
            .assign(to: &self.$combinedLocationData)
    }
    
    @Published private var combinedLocationData: (CLLocation, CLHeading)? {
        didSet {
            guard let (loc, heading) = combinedLocationData else { return }
            self.lastKnownLocation = loc
            
            // Hvis vi ikke har en kafé ennå, prøv å finn en!
            if currentCafe == nil {
                findCoffee()
            }
            
            updateCompass(userLoc: loc, userHead: heading)
        }
    }
    
    // Funksjonen som henter data
    func findCoffee() {
        guard let loc = lastKnownLocation else { return }
        
        Task {
            do {
                let cafe = try await cafeService.fetchNearestCafe(
                    loc: loc.coordinate,
                    criteria: filters
                )
                
                DispatchQueue.main.async {
                    self.currentCafe = cafe
                    // Oppdaterer kompasset med en gang hvis vi fikk treff
                    if let userLoc = self.locationService.userLocation,
                       let userHead = self.locationService.userHeading {
                        self.updateCompass(userLoc: userLoc, userHead: userHead)
                    }
                }
            } catch {
                print("Feil ved henting: \(error)")
            }
        }
    }
    
    private func updateCompass(userLoc: CLLocation, userHead: CLHeading) {
        guard let cafe = currentCafe else { return }
        
        // 1. Avstand
        let cafeLoc = CLLocation(latitude: cafe.latitude, longitude: cafe.longitude)
        let dist = userLoc.distance(from: cafeLoc)
        self.distanceToCafe = String(format: "%.0f meter", dist)
        
        // 2. Rotasjon
        let bearing = userLoc.coordinate.bearing(to: cafe.coordinate)
        let heading = userHead.trueHeading
        let rotation = bearing - heading
        
        withAnimation(.linear(duration: 0.2)) {
            self.needleRotation = rotation
        }
    }
}
