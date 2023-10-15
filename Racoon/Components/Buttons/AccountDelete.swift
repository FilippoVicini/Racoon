import SwiftUI
import RealmSwift

struct AccountDeleteButton: View {
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    @State private var deleteError: String = ""
    
    var body: some View {
        Button(action: {
            deleteAccount()
        }) {
            HStack(spacing: 30) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 25))
                    .foregroundColor(Color.main)
                
                Text("Delete account")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.leading, 25)
        }
    }
    
    
    private func deleteAccount() {
        // Perform the account deletion logic here
        // You can use RealmSwift to handle user authentication and deletion
        // Example:
         let app = App(id: "application-0-qsvxj")
        let user = app.currentUser

        // Ensure the user is logged in before attempting to delete
        guard let user = app.currentUser else {
            // Handle the case where there's no logged-in user
            deleteError = "No user logged in."
            return
        }

        // Use user.delete() to delete the account
        user.delete { (error) in
            if let error = error {
                // Handle the error
                deleteError = "Account deletion failed: \(error.localizedDescription)"
            } else {
                username = ""
                isLoggedIn = false
            }
        }
    }
}
