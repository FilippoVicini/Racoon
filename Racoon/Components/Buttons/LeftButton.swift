import SwiftUI

struct LeftButton: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("uid") var userID: String = ""

    var body: some View {
        Spacer()
        Link(destination: URL(string: "https://wiki.openstreetmap.org")!) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(Color.black)
            Text("Share")
                .foregroundColor(.black)
                .padding(.vertical, 14)
               }
        .frame(width: UIScreen.main.bounds.width * 0.36)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 8)
    }
}
