import SwiftUI

struct FilterView: View {
    @Binding var criteria: SearchCriteria
    var onApply: () -> Void // Funksjon som kjøres når man lukker
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.latteCream.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 25) {
                
                Text("Hva ser du etter?")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.deepCharcoal)
                    .padding(.top, 20)
                
                Divider()
                
                // Åpningstider
                ToggleRow(title: "Må være åpen nå", isOn: $criteria.mustBeOpen, icon: "clock.fill")
                
                // Fasiliteter
                Text("Fasiliteter")
                    .font(.headline)
                    .foregroundColor(.deepCharcoal.opacity(0.6))
                    .padding(.top, 10)
                
                ToggleRow(title: "Uteservering ☀️", isOn: $criteria.wantsOutdoor, icon: "sun.max.fill")
                ToggleRow(title: "Vegetarvennlig 🥬", isOn: $criteria.wantsVegetarian, icon: "leaf.fill")
                ToggleRow(title: "God Wifi 💻", isOn: $criteria.wantsWifi, icon: "wifi")
                
                // Rating Slider
                VStack(alignment: .leading) {
                    Text("Minimum Rating: \(String(format: "%.1f", criteria.minRating))")
                        .font(.headline)
                        .foregroundColor(.deepCharcoal)
                    
                    Slider(value: $criteria.minRating, in: 0...5, step: 0.5)
                        .accentColor(.burntOrange)
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                // Søk-knapp
                Button(action: {
                    onApply() // Oppdaterer søket
                    dismiss()
                }) {
                    Text("Oppdater Kompasset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.burntOrange)
                        .cornerRadius(15)
                        .shadow(color: .burntOrange.opacity(0.4), radius: 10, x: 0, y: 5)
                }
            }
            .padding(30)
        }
    }
}

// Hjelpe-view for toggles
struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.burntOrange)
                .frame(width: 24)
            Text(title)
                .font(.body)
                .foregroundColor(.deepCharcoal)
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .burntOrange))
                .labelsHidden()
        }
        .padding(.vertical, 5)
    }
}
