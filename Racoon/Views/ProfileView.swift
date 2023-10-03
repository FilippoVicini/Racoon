import SwiftUI

struct ProfileView: View {
    @State private var newPassword = ""
    @State private var isShowingChangePassword = false
    @State private var isShowingDeleteAccountAlert = false

    // Replace with actual user data
    let userEmail = "user@example.com"

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 20)

                Text(userEmail)
                    .font(.title)
                    .foregroundColor(.black)

                Spacer()

                Button(action: {
                    isShowingChangePassword.toggle()
                }) {
                    Text("Change Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                .sheet(isPresented: $isShowingChangePassword) {
                    ChangePasswordView(newPassword: $newPassword)
                }

                Button(action: {
                    // Make an HTTP request to delete the account
                    guard let url = URL(string: "https://your-backend.com/delete-account") else { return }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "DELETE"
                    
                    // Add authentication headers if required
                    // request.setValue("Bearer <access_token>", forHTTPHeaderField: "Authorization")
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error deleting account: \(error)")
                            // Handle the error and provide user feedback
                        } else {
                            // Handle the successful account deletion
                            // Update your app's state or perform any required actions
                        }
                    }.resume()
                }) {
                    Text("Delete Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
                .alert(isPresented: $isShowingDeleteAccountAlert) {
                    Alert(
                        title: Text("Delete Account"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            // Perform account deletion here
                            // You can add your account deletion logic here
                        },
                        secondaryButton: .cancel()
                    )
                }

                Spacer()
            }
            .padding()
            .navigationBarTitle("Profile")
        }
    }
}

struct ChangePasswordView: View {
    @Binding var newPassword: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Change Password")) {
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        // Perform password change logic here
                        // You can add your password change logic here
                    }) {
                        Text("Change Password")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Change Password")
        }
    }
}
