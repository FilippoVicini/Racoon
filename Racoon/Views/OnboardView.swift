import SwiftUI

struct OnboardingView: View {
    @State private var isOnboardingComplete = false
    @State private var showRegistrationView = false
    @State private var showLoginView = false
    @Binding var username: String
    @Binding var isLoggedIn: Bool
    var slides: [OnboardingSlide] = [
        OnboardingSlide(image: "onboard1", title: "Welcome to Raccon", description: "Learn about the local amenities with Racoon. Water fountains, restrooms, and public bike maintenance areas and much more!"),
        OnboardingSlide(image: "onboard2", title: "Don't overload your data", description: "Only the nearby data will be loaded by Racoon, guaranteeing a quick and reliable deployment."),
        OnboardingSlide(image: "onboard3", title: "Contribute!", description: "Our goal is to assist as many individuals as we can. Thus, if you come across a feature that isn't mapped. Be sure to include it.")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    ForEach(slides, id: \.self) { slide in
                        OnboardingSlideView(slide: slide)
                            .onTapGesture {
                                if slide.id == slides.last?.id {
                                    isOnboardingComplete = true
                                }
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                NavigationLink(
                    destination: RegistrationView(username: $username, isLoggedIn: $isLoggedIn),
                    isActive: $isOnboardingComplete,
                    label: {
                        Button(action: {
                            isOnboardingComplete = true
                        }) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.main)
                                .cornerRadius(10)
                                .padding()
                        }
                        .transition(.opacity)
                    }
                )
                .navigationBarHidden(true)
            }
        }
    }
}

struct OnboardingSlide: Identifiable, Hashable {
    var id = UUID()
    var image: String
    var title: String
    var description: String
}

struct OnboardingSlideView: View {
    var slide: OnboardingSlide
    
    var body: some View {
        VStack {
            Image(slide.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
            
            Text(slide.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(slide.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

