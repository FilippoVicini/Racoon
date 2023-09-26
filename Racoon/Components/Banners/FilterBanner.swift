import SwiftUI

struct FilterBanner: View {
    var body: some View {
        HStack {
            Spacer()
            
            // Circle Button 1
            CircleButton(iconName: "circle.fill")
            
            Spacer()
            
            // Circle Button 2
            CircleButton(iconName: "circle.fill")
            
            Spacer()
        }
        .padding()
    }
}

struct CircleButton: View {
    var iconName: String
    
    var body: some View {
        Button(action: {
            // Add action for the circle button
        }) {
            Image(systemName: iconName)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
}

struct FilterBanner_Previews: PreviewProvider {
    static var previews: some View {
        FilterBanner()
            .previewLayout(.sizeThatFits)
    }
}
