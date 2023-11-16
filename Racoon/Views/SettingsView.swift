import SwiftUI

struct SettingsView: View {
    @Binding var email: String 
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showChangePasswordAlert = false
    @State private var showDeleteAccountAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    Text("Email: \(email)")
                }

                Section(header: Text("Change Password")) {
                    TextField("New Password", text: $newPassword)
                    TextField("Confirm Password", text: $confirmPassword)

                    Button(action: {
                        changePassword()
                    }) {
                        Text("Change Password")
                    }
                    .alert(isPresented: $showChangePasswordAlert) {
                        Alert(
                            title: Text("Password Changed"),
                            message: Text("Your password has been changed successfully."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }

            }
            .navigationBarTitle("Settings")
        }
    }

    private func changePassword() {
        showChangePasswordAlert = true
    }

    private func deleteAccount() {
    
    }
}
