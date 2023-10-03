import SwiftUI

struct PopupView: View {
    var fountain: WaterFountain
    @Binding var isPopupVisible: Bool // Add a binding for controlling visibility

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Close") {
                    isPopupVisible = false // Close the popup
                }
                .padding()
            }
            .padding(.trailing) // Add some spacing to the close button
            
    
            
            // Button to open the location in Apple Maps
            Button(action: {
                openAppleMaps()
            }) {
                Text("Open in Apple Maps")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal) // Add horizontal padding
            
            // Button to open the location in Google Maps
            Button(action: {
                openGoogleMaps()
            }) {
                Text("Open in Google Maps")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal) // Add horizontal padding
        }
        .frame(width: 300, height: 200)
             .background(Color.white)
             .cornerRadius(10)
             .shadow(radius: 5)
             .scaleEffect(isPopupVisible ? 1.0 : 0.5) // Scale the view when it's visible
             .opacity(isPopupVisible ? 1.0 : 0.0) // Make it transparent when not visible
             .animation(.spring()) // Add an animation when the state changes
         }

    private func openAppleMaps() {
        if let url = URL(string: "http://maps.apple.com/?daddr=\(fountain.latitude),\(fountain.longitude)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func openGoogleMaps() {
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(fountain.latitude),\(fountain.longitude)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
