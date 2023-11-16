import SwiftUI
import RealmSwift

struct RegistrationView: View {
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var registrationError = ""
    @State private var registrationConfirmed = false
    @State private var acceptMarketingConditions = false
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
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
                Button(action: {
                    acceptMarketingConditions.toggle()
                }) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .border(Color.gray, width: 1)
                            
                            if acceptMarketingConditions {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                            }
                        }
                        Link("Accept Marketing conditions", destination: URL(string: "https://www.racoonapp.com/terms-conditions")!)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 10)
                
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
                        .background(Color.main)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
    private func register(email: String, password: String, confirmPassword: String) {
        if password == confirmPassword {
            let app = App(id: "application-0-qsvxj")
            
            app.emailPasswordAuth.registerUser(email: email, password: password) { [self] error in
                if let error = error {
                    print("Failed to register: \(error.localizedDescription)")
                    registrationError = "Registration failed: \(error.localizedDescription)"
                } else {
                    app.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
                        switch result {
                        case .success(let user):
                            print("Logged in as user: \(user.id)")
                            self.username = user.id
                            self.isLoggedIn = true
                            UserDefaults.standard.set(self.username, forKey: "username")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            registrationError = ""
                        case .failure(let error):
                            print("Failed to log in after registration: \(error.localizedDescription)")
                            registrationError = "Registration succeeded, but login failed: \(error.localizedDescription)"
                            isLoggedIn = false
                        }
                    }
                }
            }
        } else {
            registrationError = "Passwords do not match."
        }
    }
}
