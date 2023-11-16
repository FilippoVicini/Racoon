import SwiftUI

struct LoadingPopup: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ProgressView("Loading Data")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
    }
}



