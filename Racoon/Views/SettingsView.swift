//
//  SettingsView.swift
//  Racoon
//
//  Created by Filippo Vicini on 06/10/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showChangePasswordAlert = false
    @State private var showDeleteAccountAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    Text("Email: user@example.com") // Replace with user's email
                }
                
                Section(header: Text("Change Password")) {
                    TextField("New Password", text: $newPassword)
                    TextField("Confirm Password", text: $confirmPassword)
                    
                    Button(action: {
                        // Perform password change logic here
                        // You should send newPassword and confirmPassword to your backend API
                        // Handle success or failure accordingly
                        showChangePasswordAlert = true
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
                                // Perform account deletion logic here
                                // You should call your backend API to delete the account
                                // Handle success or failure accordingly
                                // After successful deletion, log the user out
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}
