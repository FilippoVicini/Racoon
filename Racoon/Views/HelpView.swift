import SwiftUI
import WebKit


struct HelpView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Help Center")
                .font(.title)
                .bold()
                .foregroundColor(.main)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            Link(destination: URL(string: "https://www.racoonapp.com")!) {
                HelpItemView(iconName: "questionmark.circle", title: "FAQ")
                      }
            Link(destination: URL(string: "mailto:info@racoonapp.com")!) {
                HelpItemView(iconName: "envelope.open", title: "Contact Support")
            }
            
            Link(destination: URL(string: "https://www.racoonapp.com/privacy")!) {
                HelpItemView(iconName: "lock.shield", title: "Privacy Policy")
            }
            
            Link(destination: URL(string: "https://www.racoonapp.com/terms")!) {
                HelpItemView(iconName: "doc.plaintext", title: "Terms and Conditions")
            }
            Link(destination: URL(string: "mailto:info@racoonapp.com")!) {
                HelpItemView(iconName: "heart", title: "Support")
            }
            
            Spacer()
            
            Text("Racoon Help Version: 1.0, All rights reserved")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}

struct HelpItemView: View {
    var iconName: String
    var title: String
    
    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: iconName)
                .font(.system(size: 25))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.leading, 25)
    }
}


struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}