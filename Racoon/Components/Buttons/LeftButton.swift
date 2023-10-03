import SwiftUI

struct LeftButton: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("uid") var userID: String = ""

    var body: some View {
        Spacer()
        Button(action: {
            // Call the signOut function
            signOut()
        }) {
            Image(systemName: "person")
                .foregroundColor(Color.black)
            Text("Sign Out")
                .foregroundColor(.black)
                .padding(.vertical, 14)
        }
        .frame(width: UIScreen.main.bounds.width * 0.36)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 8)
    }

    private func signOut() {
        // Here, you can perform client-side actions to sign the user out.
        // Clear any client-side data or flags related to the user's authentication state.
        isLoggedIn = false

        // Clear the user ID stored in AppStorage
        userID = ""

        // Clear any other user-related data stored locally, if applicable.
        // For example, you might want to clear the username stored in UserDefaults.

        // You should also communicate with your server or MongoDB Atlas backend
        // to invalidate the user's session or access token on the server.
        // This step is necessary to ensure that the user is fully logged out.
        // The server should handle session invalidation and token revocation.

        // For server communication, you may send a request to your backend
        // with the user's session information for proper logout handling.
        // The exact implementation details depend on your backend setup.

        // Optionally, navigate to a different view or perform any other actions
        // needed after signing out.
    }
}
