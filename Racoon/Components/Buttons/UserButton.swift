import SwiftUI

struct UserButton: View {
    @State private var isProductPageActive = false
    @State private var username = UserDefaults.standard.string(forKey: "username") ?? ""

    var body: some View {
        Spacer()
        Button(action: {
            isProductPageActive = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: UIScreen.main.bounds.width * 0.46, height: 56) // Adjust the height as needed
                    .foregroundColor(.white)
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color.main) // Assuming you have a Color named 'main'
                    Text("Contribute")
                        .foregroundColor(.main) // Assuming you have a Color named 'main'
                }
                .padding(.vertical, 14) // Adjust the vertical padding as needed
            }
        }
        .sheet(isPresented: $isProductPageActive) {
            ProductsView(username: username)
        }
    }
}
