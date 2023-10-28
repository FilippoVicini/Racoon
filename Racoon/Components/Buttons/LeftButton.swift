import SwiftUI

struct LeftButton: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("uid") var userID: String = ""
    @State private var isShareSheetPresented = false

    var body: some View {
        Spacer()
        
        Button(action: {
            isShareSheetPresented.toggle()
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(Color.main)
            Text("Share")
                .foregroundColor(.main)
                .padding(.vertical, 14)
        }
        .frame(width: UIScreen.main.bounds.width * 0.46)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 8)
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityView(activityItems: [URL(string: "https://apps.apple.com/it/app/racoon/id6469004016")!])
        }
    }
}


struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to do here
    }
}
