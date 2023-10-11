import SwiftUI

struct SettingsView: View {
    @Binding var email: String // Bind the user's email
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showChangePasswordAlert = false
    @State private var showDeleteAccountAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    Text("Email: \(email)") // Display the user's email
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

                Section {
                    Button(action: {
                        showDeleteAccountAlert = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showDeleteAccountAlert) {
                        Alert(
                            title: Text("Delete Account?"),
                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteAccount()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }

    private func changePassword() {
        // Implement password change logic here
        // You should send newPassword and confirmPassword to your backend API
        // Handle success or failure accordingly
        // After a successful change, set showChangePasswordAlert to true
        showChangePasswordAlert = true
    }

    private func deleteAccount() {
        // Implement account deletion logic here
        // Delete the user's account from your backend API
        // Handle success or failure accordingly
        // After a successful deletion, you can navigate the user back to the login screen or perform any other desired action
    }
}
