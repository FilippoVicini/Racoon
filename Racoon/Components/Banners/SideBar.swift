import SwiftUI

struct SideBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            Text("Hello User")
                .font(.title)
                .bold()
                .foregroundColor(.orange)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            // Add two horizontally aligned icons with buttons underneath
          
            SidebarItemView(iconName: "house", title: "Home")
            SidebarItemView(iconName: "message", title: "Messages")
            SidebarItemView(iconName: "calendar", title: "Calendar")
            SidebarItemView(iconName: "person", title: "Profile")
            SidebarItemView(iconName: "gear", title: "Settings")
            SidebarItemView(iconName: "bookmark", title: "Bookmarks")
            SidebarItemView(iconName: "arrow.right.circle", title: "Logout")
            
            Spacer()
            
            Text("Racoon Version: 1.0, All rights reserved")
                          .font(.footnote)
                          .foregroundColor(.gray)
                          .padding(.leading, 10)
                          .padding(.bottom, 10)
           
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}

struct SidebarItemView: View {
    var iconName: String
    var title: String
    
    var body: some View {
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

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
