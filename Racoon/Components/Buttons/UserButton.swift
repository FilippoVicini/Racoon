import SwiftUI

struct UserButton: View {
    var body: some View {
        Spacer()
        Button(action: {
            // Your action when the button is tapped
        }) {
            Image(systemName: "water.waves")
                .foregroundColor(Color.black)
            Text("Water")
                .foregroundColor(.black)
                .padding(.vertical, 14)
             
        }
        .frame(width: UIScreen.main.bounds.width * 0.52)
        .background(Color.white)
        .cornerRadius(30)
        
    }
}

