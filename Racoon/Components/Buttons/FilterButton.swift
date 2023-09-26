import SwiftUI

struct FilterButton: View {
    @Binding var isFilterBannerVisible: Bool // Binding to toggle the filter banner
    
    var body: some View {
        Button(action: {
            // Toggle the visibility of the filter banner when the button is pressed
            isFilterBannerVisible.toggle()
        }) {
            Image(systemName: "slider.horizontal.3")
                .font(.title3)
                .foregroundColor(.black)
                .padding(12)
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 4)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
