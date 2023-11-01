import SwiftUI
import RealmSwift

struct LoginView: View {
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var loginSuccess = false
    @State private var isLoadingData = false // Add loading state
    @State private var isRedirecting = false
    @State private var acceptMarketingConditions = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220, height: 220)
                    .padding(.bottom, 30)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                Button(action: {
                         // Toggle the acceptMarketingConditions boolean when the button is pressed
                         acceptMarketingConditions.toggle()
                     }) {
                         HStack {
                             ZStack {
                                 RoundedRectangle(cornerRadius: 20) // Add corner radius
                                     .frame(width: 24, height: 24)
                                     .foregroundColor(.white)
                                     .border(Color.gray, width: 1) // Black border
                                 
                                 if acceptMarketingConditions {
                   
                                     Image(systemName: "checkmark")
                                         .foregroundColor(.black)
                                      
                                        
                                 }
                             }
                             Text("Accept Marketing conditions")
                                 .foregroundColor(.gray)
                         }
                     }
                     .padding(.vertical, 10)


                Button(action: {
                    login(email: email, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.main)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                NavigationLink(
                    destination: RegistrationView(username: $username, isLoggedIn: $isLoggedIn)
                        .navigationBarBackButtonHidden(true),
                    label: {
                        Text("Don't have an account? Register here.")
                            .foregroundColor(Color.gray)
                    }
                )
                NavigationLink(
                    destination: PasswordRecoveryView(),
                    label: {
                        Text("Forgot Password?")
                            .foregroundColor(Color.gray)
                    })
                if isLoadingData { // Show loading popup when data is loading
                    LoadingPopup()
                        .zIndex(1)
                }
                
                if loginSuccess {
                    Text("Login successful!")
                        .foregroundColor(.green)
                        .padding()
                } else if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
            }
            .padding()
            .navigationBarTitle("Login", displayMode: .inline)
        }
        
        
        
    }
    
    private func login(email: String, password: String) {
        let app = App(id: "application-0-qsvxj")
        let credentials = Credentials.emailPassword(email: email, password: password)
        
        app.login(credentials: credentials) { result in
            switch result {
            case .success(let user):
                print("Logged in as user: \(user.id)")
                self.username = user.id // Update the @Binding variable
                self.isLoggedIn = true // Update the login state
                UserDefaults.standard.set(self.username, forKey: "username")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                
                // Store the marketing conditions acceptance state
                UserDefaults.standard.set(self.acceptMarketingConditions, forKey: "acceptMarketingConditions")
                
                loginSuccess = true // Set success state
                loginError = "" // Clear any previous error message
            case .failure(let error):
                print("Failed to login: \(error.localizedDescription)")
                loginError = "Login failed: \(error.localizedDescription)" // Set error message
                loginSuccess = false // Set success state to false
            }
        }
    }
}
