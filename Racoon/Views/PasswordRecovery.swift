import SwiftUI
import RealmSwift


struct PasswordRecoveryView: View {
    @State private var email = ""
    @State private var recoveryError = ""
    @State private var recoverySuccess = false
    
    var body: some View {
        VStack {
            Text("Password Recovery")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .autocapitalization(.none)
            
            Button(action: {
                recoverPassword(email: email)
            }) {
                Text("Recover Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            
            if recoverySuccess {
                Text("Password recovery email sent successfully!")
                    .foregroundColor(.green)
                    .padding()
            } else if !recoveryError.isEmpty {
                Text(recoveryError)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Password Recovery", displayMode: .inline)
    }
    
    private func recoverPassword(email: String) {
        let app = App(id: "application-0-qsvxj")
        
        app.emailPasswordAuth.sendResetPasswordEmail(email) { error in
            if let error = error {
                print("Failed to send password recovery email: \(error.localizedDescription)")
                recoveryError = "Password recovery failed: \(error.localizedDescription)"
                recoverySuccess = false
            } else {
                print("Password recovery email sent successfully.")
                recoveryError = ""
                recoverySuccess = true
            }
        }
    }
    
}
