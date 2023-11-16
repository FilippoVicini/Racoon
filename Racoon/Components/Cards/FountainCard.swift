import SwiftUI

struct FountainCard: View {
    let fountain: WaterFountain
    @Binding var selectedFountain: WaterFountain?

    var body: some View {
        Button(action: {
            selectedFountain = fountain
        }) {
            VStack {
                Text("Fountain")
                    .font(.headline)
                Text("Foutain")
                    .font(.subheadline)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
