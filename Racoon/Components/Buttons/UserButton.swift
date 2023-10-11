import SwiftUI

struct UserButton: View {
    var body: some View {
        Spacer()
        Link(destination: URL(string: "https://wiki.openstreetmap.org/wiki/How_to_contribute")!) {
                   Image(systemName: "water.waves")
                       .foregroundColor(Color.black)
                   Text("Contribute")
                       .foregroundColor(.black)
                       .padding(.vertical, 14)
               }
        .frame(width: UIScreen.main.bounds.width * 0.52)
        .background(Color.white)
        .cornerRadius(30)
        
    }
}

