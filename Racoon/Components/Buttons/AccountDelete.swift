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
            Text("Delete Account")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red) // Use your desired delete button color
                .cornerRadius(10)
        }
    }
    private func deleteAccount() {
        let app = App(id: "application-0-qsvxj") // Replace with your Realm app ID
        let dispatchGroup = DispatchGroup()
        
        // Check if a user is currently logged in
        if let user = app.currentUser {
            dispatchGroup.enter() // Enter the group before logging out
            user.logOut { error in
                defer {
                    dispatchGroup.leave() // Leave the group after log out
                }
                if let error = error {
                    print("Failed to log out: \(error.localizedDescription)")
                } else {
                    print("User logged out successfully.")
                }
            }
            
            dispatchGroup.wait() // Wait for the log out to complete
            
            // Now, delete the user account
            user.remove { error in
                if let error = error {
                    print("Failed to delete user account: \(error.localizedDescription)")
                } else {
                    print("User account deleted successfully.")
                    
                    // Reset user-related data and states
                    self.username = ""
                    self.isLoggedIn = false
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                }
            }
        } else {
            print("No user is currently logged in.")
        }
    }
}
