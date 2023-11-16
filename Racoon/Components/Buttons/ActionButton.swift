import SwiftUI

struct ActionButton: View {
    @Binding var menuOpened: Bool
    
    var body: some View {
        Button(action: {
            self.menuOpened.toggle()
        }, label: {
            Image(systemName: "person")
                .font(.title3)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 2)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



