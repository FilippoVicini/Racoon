import SwiftUI

struct InfoPopup: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text("Welcome to Racoon!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.main)
                    .padding(.top, 20)

                Text("Racoon is built for travelers or anyone seeking local amenities. You can discover the world, starting with water fountains in your area. Weather you are a daily commuter looking for some refreshment or a backpacker. \n Racoon is built for you. \n \n This is only the beginning ")
                    .foregroundColor(.black)
                    .padding()
                    .multilineTextAlignment(.center)


                Spacer()

                Button(action: {
                   openRacoonWebsite()
                }) {
                    Text("Learn more")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.main)
                        .cornerRadius(10)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(width: UIScreen.main.bounds.size.width * 0.8, height: UIScreen.main.bounds.size.height * 0.5)
            .alignmentGuide(.top) { dimension in
                dimension[.bottom]
            }
        }
    }

    private func openRacoonWebsite() {
        if let racoonURL = URL(string: "https://racoonapp.com") {
            UIApplication.shared.open(racoonURL)
        }
    }
}
