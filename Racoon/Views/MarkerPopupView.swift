import SwiftUI

struct PopupView: View {
    var fountain: WaterFountain
    @Binding var isPopupVisible: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Racoon will guide you")
                    .font(.title2)
                    .padding()
                Spacer()
            }
            .foregroundColor(Color.main)

            Text("Fountain ID: \(fountain.id)") // Display the fountain ID
                .font(.subheadline)
                .padding()

            VStack(spacing: 20) {
                Button(action: {
                    openAppleMaps()
                }) {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.main)
                        Text("Open in Apple Maps")
                            .padding()
                    }
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    openGoogleMaps()
                }) {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.main)
                        Text("Open in Google Maps")
                            .padding()
                    }
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Button("Close") {
                isPopupVisible = false
            }
            .foregroundColor(.gray)
            .padding()
        }
        .frame(width: 300, height: 300)
        .background(Color.white)
        .cornerRadius(15)
        .scaleEffect(isPopupVisible ? 1.0 : 0.5)
        .opacity(isPopupVisible ? 1.0 : 0.0)
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

