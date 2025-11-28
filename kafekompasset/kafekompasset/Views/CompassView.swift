import SwiftUI

struct CompassView: View {
    @StateObject private var vm = CompassViewModel()
    @State private var showFilters = false
    
    var body: some View {
        ZStack {
            // Bakgrunn
            Color.latteCream.edgesIgnoringSafeArea(.all)
            
            VStack {
                // HEADER med Filter-knapp
                HStack {
                    Button(action: { showFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.deepCharcoal)
                            .padding(12)
                            .background(Color.softSand)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("kafe\nkompasset")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(.deepCharcoal)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Usynlig knapp for balanse
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .padding(12)
                        .opacity(0)
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                Spacer()
                
                // --- KOMPASSET ---
                ZStack {
                    Circle()
                        .stroke(Color.softSand, lineWidth: 2)
                        .frame(width: 300, height: 300)
                    
                    // Nord-pil (liten)
                    VStack {
                        Text("N")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.burntOrange)
                            .padding(5)
                            .background(Circle().fill(Color.latteCream))
                        Spacer()
                    }
                    .frame(height: 300)
                    
                    // Hovedpil
                    Image(systemName: "location.north.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .foregroundColor(.burntOrange)
                        .shadow(color: .burntOrange.opacity(0.3), radius: 15, x: 0, y: 10)
                        .rotationEffect(Angle(degrees: vm.needleRotation))
                }
                
                Spacer()
                
                // --- INFO PANEL ---
                VStack(spacing: 12) {
                    if let cafe = vm.currentCafe {
                        Text(cafe.name)
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundColor(.deepCharcoal)
                            .multilineTextAlignment(.center)
                        
                        // Rating og Pris
                        HStack(spacing: 8) {
                            if let rating = cafe.rating {
                                Label("\(String(format: "%.1f", rating))", systemImage: "star.fill")
                                    .foregroundColor(.orange)
                            }
                            if let price = cafe.priceLevel {
                                Text("•").foregroundColor(.gray)
                                Text(price).foregroundColor(.deepCharcoal)
                            }
                        }
                        
                        // Fasiliteter (Scrollbar liste)
                        if let features = cafe.features, !features.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(features, id: \.self) { feature in
                                        Text(feature)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.softSand)
                                            .cornerRadius(8)
                                            .foregroundColor(.deepCharcoal)
                                    }
                                }
                            }
                            .frame(height: 30)
                        }
                    } else {
                        Text("Søker etter kaffe...")
                            .foregroundColor(.gray)
                    }
                    
                    Divider().padding(.vertical, 5)
                    
                    // Avstand
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Text(vm.distanceToCafe.replacingOccurrences(of: " meter", with: ""))
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundColor(.deepCharcoal)
                        Text("m")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: -5)
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showFilters) {
            FilterView(criteria: $vm.filters, onApply: {
                vm.findCoffee()
            })
        }
    }
}
