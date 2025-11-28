import Foundation
import CoreLocation
import OSLog // <--- Viktig for loggingen

class CafeService {
    // Din IP-adresse
    private let baseURL = "http://192.168.0.66:8000/api/v1/cafe/nearest"

    func fetchNearestCafe(loc: CLLocationCoordinate2D, criteria: SearchCriteria) async throws -> CafeResponse? {
        
        Logger.network.info("🚀 STARTER SØK mot: \(self.baseURL)")
        
        // 1. Forbered data
        var features: [String] = []
        if criteria.wantsOutdoor { features.append("outdoor_seating") }
        if criteria.wantsVegetarian { features.append("vegetarian_food") }
        if criteria.wantsWifi { features.append("wifi") }

        let requestBody = SearchRequest(
            latitude: loc.latitude,
            longitude: loc.longitude,
            minRating: criteria.minRating,
            openNow: criteria.mustBeOpen,
            requiredFeatures: features
        )
        
        guard let url = URL(string: baseURL) else {
            Logger.network.fault("🛑 Ugyldig URL: \(self.baseURL)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // 2. Logg hva vi sender (Request Body)
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                Logger.network.debug("📦 SENDER JSON: \(jsonString)")
            }
            
            // 3. Utfør kallet
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.network.error("⚠️ Ingen gyldig HTTP-respons mottatt")
                return nil
            }
            
            // 4. Logg statuskode
            if httpResponse.statusCode == 200 {
                Logger.network.info("✅ SERVER SVARTE: 200 OK")
            } else {
                Logger.network.error("🔥 SERVER FEIL: Kode \(httpResponse.statusCode)")
            }
            
            // 5. Logg svaret (Response Body)
            if let responseString = String(data: data, encoding: .utf8) {
                Logger.network.debug("📥 MOTTOCK JSON: \(responseString)")
            }
            
            if httpResponse.statusCode != 200 { return nil }

            // 6. Dekoding
            let result = try JSONDecoder().decode(CafeResponse.self, from: data)
            
            if result.found {
                Logger.network.notice("☕️ Fant kafé: \(result.name)")
            } else {
                Logger.network.warning("🤷‍♂️ Server fant ingen resultater (found: false)")
            }
            
            return result
            
        } catch {
            Logger.network.fault("💥 KRASJ I NETTVERK: \(error.localizedDescription)")
            return nil
        }
    }
}
