import SwiftUI

struct LeftButton: View {
    @AppStorage("uid") var userID: String = ""
    var body: some View {
        Spacer()
        Button(action: {

        }) {
            Image(systemName: "person")
                .foregroundColor(Color.black)
            Text("SignOut")
                .foregroundColor(.black)
                .padding(.vertical, 14) // Adjust the vertical padding
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.36)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 8) // Adjust the padding as needed
        
    }
}

struct LeftButton_Previews: PreviewProvider {
    static var previews: some View {
        UserButton()
    }
}
