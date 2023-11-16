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
                    .frame(width: UIScreen.main.bounds.width * 0.46, height: 56) 
                    .foregroundColor(.white)
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color.main)
                    Text("Contribute")
                        .foregroundColor(.main)
                }
                .padding(.vertical, 14)
            }
        }
        .sheet(isPresented: $isProductPageActive) {
            ProductsView(username: username)
        }
    }
}
