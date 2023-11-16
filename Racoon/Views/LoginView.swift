import SwiftUI
import RealmSwift

struct LoginView: View {
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var loginSuccess = false
    @State private var isLoadingData = false 
    @State private var isRedirecting = false
    @State private var acceptMarketingConditions = false

    var body: some View {
        NavigationView {
            ScrollView {
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

                    Spacer()

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

                    if isLoadingData {
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
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true) 
        }
    }

    
    private func login(email: String, password: String) {
        let app = App(id: "application-0-qsvxj")
        let credentials = Credentials.emailPassword(email: email, password: password)
        
        app.login(credentials: credentials) { result in
            switch result {
            case .success(let user):
                print("Logged in as user: \(user.id)")
                self.username = user.id
                self.isLoggedIn = true
                UserDefaults.standard.set(self.username, forKey: "username")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")

                UserDefaults.standard.set(self.acceptMarketingConditions, forKey: "acceptMarketingConditions")
                
                loginSuccess = true
                loginError = ""
            case .failure(let error):
                print("Failed to login: \(error.localizedDescription)")
                loginError = "Login failed: \(error.localizedDescription)"
                loginSuccess = false 
            }
        }
    }
}
