import SwiftUI

struct AuthView: View {
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    @State private var showRegistrationView = false
    @State private var showLoginView = false
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: -100) {
                ZStack(alignment: .top) {
                    Image("auth")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.75)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                    
                    Text("Welcome\nExplorers")
                        .font(.system(size: 52))
                        .multilineTextAlignment(.trailing)
                        .padding(.top, 50)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(2)
                }
                
                VStack(spacing: 10) {
                    NavigationLink(
                        destination: RegistrationView(username: $username, isLoggedIn: $isLoggedIn)
                            .navigationBarBackButtonHidden(true),
                        isActive: $showRegistrationView
                    ) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: LoginView(username: $username, isLoggedIn: $isLoggedIn)
                            .navigationBarBackButtonHidden(true),
                        isActive: $showLoginView
                    ) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        self.showRegistrationView = true
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.main)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        self.showLoginView = true
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.main)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.height * 0.3) 
                .padding(.bottom,50 )
            }
        }
    }
}
