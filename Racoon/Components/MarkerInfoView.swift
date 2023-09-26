//
//  MarkerInfoView.swift
//  Racoon
//
//  Created by Filippo Vicini on 23/09/23.
//

import Foundation
import SwiftUI
struct MarkerInfoView: View {
    let fountain: WaterFountain
    @State private var isShowingLookAround = false // Toggle to show/hide the "Look Around" view

    var body: some View {
        VStack {
            Text("Water Fountain")
                .font(.headline)

            Text("Distance: \(calculateDistance()) meters")
                .font(.subheadline)

            // Additional information about the water fountain
            Text("Additional Info: ...")

            Button("Look Around") {
                isShowingLookAround.toggle()
            }
            .sheet(isPresented: $isShowingLookAround) {
                // Show a Look Around view when the button is tapped
               
            }
        }
        .padding()
    }

    // Calculate the distance to the water fountain from the user's location
    private func calculateDistance() -> Double {
        // You can use Core Location to calculate the distance
        // between userLocation and fountain's coordinates here
        // For simplicity, you can return a static value for now
        return 500 // Replace with actual calculation
    }
}
