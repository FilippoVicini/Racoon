import SwiftUI
import SwiftData
import RealmSwift
import Realm

let realmApp = RealmSwift.App(id: "application-0-qsvxj") 
let useEmailPasswordAuth = true 



@main
struct RacoonApp: SwiftUI.App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
