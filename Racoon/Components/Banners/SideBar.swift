import SwiftUI

struct SideBar: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("uid") var userID: String = ""
    @State private var isSidebarOpened = false
    @State private var isSettingsPageActive = false
    @State private var isHelpPageActive = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            Text("Racoon")
                .font(.title)
                .bold()
                .foregroundColor(.main)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            SidebarItemView(iconName: "house", title: "Home") {
                isSidebarOpened = false
            }
            SidebarItemView(iconName: "person", title: "Profile") {
                isHelpPageActive = true
            }
            SidebarItemView(iconName: "gear", title: "Settings") {
                isSettingsPageActive = true
                
            }
            SidebarItemView(iconName: "slider.horizontal.3", title: "More about Racoon") {
                
            }
            SidebarItemView(iconName: "arrow.right.circle", title: "SignOut") {
                signOut()
            }
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
                        SettingsView()
                    }
        .sheet(isPresented: $isHelpPageActive) {
                        HelpView()
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
                    .foregroundColor(.gray)
                
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
