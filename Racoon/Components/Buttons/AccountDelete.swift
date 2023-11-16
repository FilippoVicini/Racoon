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

         let app = App(id: "application-0-qsvxj")
        let user = app.currentUser

        guard let user = app.currentUser else {
            deleteError = "No user logged in."
            return
        }

        user.delete { (error) in
            if let error = error {

                deleteError = "Account deletion failed: \(error.localizedDescription)"
            } else {
                username = ""
                isLoggedIn = false
            }
        }
    }
}
