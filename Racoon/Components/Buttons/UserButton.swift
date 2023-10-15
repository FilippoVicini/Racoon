import SwiftUI

struct UserButton: View {
    var body: some View {
        Spacer()
        Link(destination: URL(string: "https://wiki.openstreetmap.org/wiki/How_to_contribute")!) {
                   Image(systemName: "water.waves")
                       .foregroundColor(Color.main)
                   Text("Contribute")
                       .foregroundColor(.main)
                       .padding(.vertical, 14)
               }
        .frame(width: UIScreen.main.bounds.width * 0.46)
        .background(Color.white)
        .cornerRadius(30)
        
    }
}

