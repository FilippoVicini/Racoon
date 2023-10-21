import SwiftUI
import RealmSwift

struct RegistrationView: View {
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var registrationError = ""
    @State private var registrationConfirmed = false // Added confirmation state
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo") // Replace with your logo image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220, height: 100)
                    .padding(.bottom, 10)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .textContentType(.password)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .textContentType(.password)
                
                Text(registrationError)
                    .foregroundColor(.red)
                    .padding()
                NavigationLink(
                    destination: LoginView(username: $username, isLoggedIn: $isLoggedIn)
                        .navigationBarBackButtonHidden(true),
                    label: {
                        Text("Already have an account? Login here.")
                            .foregroundColor(Color.gray)
                    }
                )

                
                Button(action: {
                    register(email: email, password: password, confirmPassword: confirmPassword)
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.main) // Use your desired register button color
                        .cornerRadius(10)
                }
            }
            .padding()

        }
    }
    private func register(email: String, password: String, confirmPassword: String) {
            if password == confirmPassword {
                // Replace "Your-App-ID" with your Realm app ID
                let app = App(id: "application-0-qsvxj")
                
                app.emailPasswordAuth.registerUser(email: email, password: password) { [self] error in
                    if let error = error {
                        print("Failed to register: \(error.localizedDescription)")
                        registrationError = "Registration failed: \(error.localizedDescription)"
                    } else {
                        // Registration succeeded, now log in the user
                        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
                            switch result {
                            case .success(let user):
                                print("Logged in as user: \(user.id)")
                                self.username = user.id // Update the @Binding variable
                                self.isLoggedIn = true // Update the login state
                                UserDefaults.standard.set(self.username, forKey: "username")
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                registrationError = ""
                            case .failure(let error):
                                print("Failed to log in after registration: \(error.localizedDescription)")
                                registrationError = "Registration succeeded, but login failed: \(error.localizedDescription)"
                                isLoggedIn = false // Update the login state to indicate failure
                            }
                        }
                    }
                }
            } else {
                registrationError = "Passwords do not match."
            }
        }
    }
