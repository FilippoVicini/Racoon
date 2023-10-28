import SwiftUI
import WebKit

struct SideBar: View {
    @Binding var isLoggedIn: Bool
    @State private var username = UserDefaults.standard.string(forKey: "username") ?? ""
    @AppStorage("uid") var userID: String = ""
    @Binding var menuClosed: Bool
    @State private var isSidebarOpened = true
    @State private var isSettingsPageActive = false
    @State private var isHelpPageActive = false
    @State private var isProductPageActive = false
    @State private var email = "" // Define
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            Text("Racoon")
                .font(.title)
                .bold()
                .foregroundColor(.main)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            SidebarItemView(iconName: "plus.circle", title: "Add an amenity ") {
                isProductPageActive = true
            }
            SidebarItemView(iconName: "map", title: "Map") {
                self.menuClosed.toggle()
            }
            SidebarItemView(iconName: "person", title: "Profile") {
                isHelpPageActive = true
            }
        
           
            SidebarItemView(iconName: "network", title: "More about Racoon") {
                openRacoonWebsite()
            }
            
            
            SidebarItemView(iconName: "arrow.right.circle", title: "Sign Out") {
                signOut()
            }
         
           
            AccountDeleteButton(username: $username, isLoggedIn: $isLoggedIn)
            
            Spacer()
            Text("Racoon Version: 1.0, All rights reserved")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
        .sheet(isPresented: $isSettingsPageActive) {
                        SettingsView(email: $email)
                    }
        .sheet(isPresented: $isHelpPageActive) {
                        HelpView()
                    }
        .sheet(isPresented: $isProductPageActive) {
                
                        ProductsView(username: username)
                    }
    }
    
    private func signOut() {
        isLoggedIn = false
        userID = ""
    }
    
}

struct SidebarItemView: View {
    var iconName: String
    var title: String
    var action: () -> Void // Add an action closure
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 30) {
                Image(systemName: iconName)
                    .font(.system(size: 25))
                    .foregroundColor(Color.main)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.leading, 25)
        }
    }
}


private func openRacoonWebsite() {
    if let racoonURL = URL(string: "https://racoonapp.com") {
        UIApplication.shared.open(racoonURL)
    }
}
