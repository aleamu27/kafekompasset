import Foundation
import OSLog

extension Logger {
    // Vi bruker appens Bundle Identifier for å gruppere loggene ryddig i Console.app
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.kafekompasset"

    // --- LOGG KATEGORIER ---
    
    // For nettverkskall (API mot serveren)
    static let network = Logger(subsystem: subsystem, category: "🌍 Network")
    
    // For GPS og Kompass
    static let location = Logger(subsystem: subsystem, category: "📍 Location")
    
    // For generell app-flyt (UI, knapper osv)
    static let app = Logger(subsystem: subsystem, category: "📱 App")
}
