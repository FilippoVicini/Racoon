import SwiftUI

struct UserButton: View {
    var body: some View {
        Spacer()
        Button(action: {
            // Your action when the button is tapped
        }) {
            Image(systemName: "person")
                .foregroundColor(Color.black)
            Text("Not sure?")
                .foregroundColor(.black)
                .padding(.vertical, 14) // Adjust the vertical padding
            
             
        }
        .frame(width: UIScreen.main.bounds.width * 0.52)
        .background(Color.white)
        .cornerRadius(30)
  
        
    }
}

struct UserButton_Previews: PreviewProvider {
    static var previews: some View {
        UserButton()
    }
}
