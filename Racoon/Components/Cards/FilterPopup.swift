//
//  FilterPopup.swift
import SwiftUI

struct WaterFountainCard: View {
    let fountain: WaterFountain
    
    var body: some View {
        VStack {
            Text("Latitude: \(fountain.latitude)")
            Text("Longitude: \(fountain.longitude)")
            // Add more information about the fountain if needed
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
