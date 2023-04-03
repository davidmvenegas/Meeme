import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct MeemeApp: App {

    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Initialized Amplify")
        } catch {
            print("Could not initialize Amplify: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    struct ContentView: View {
        @Environment(\.managedObjectContext) private var viewContext

        @ObservedObject var authController = AuthController()
        @State private var imageController: ImageController?
        @State private var isSessionChecked = false

        var body: some View {
            if !isSessionChecked {
                ProgressView()
                    .onAppear(perform: checkSession)
            } else if authController.isAuthenticated {
                HomeView()
                    .environmentObject(authController)
                    .environmentObject(imageController!)
            } else {
                LandingView()
                    .environmentObject(authController)
            }
        }

        private func checkSession() {
            Task {
                do {
                    let session = try await Amplify.Auth.fetchAuthSession()
                    if session.isSignedIn {
                        authController.isAuthenticated = true
                        GlobalState.shared.currentUser = try await Amplify.Auth.getCurrentUser()
                        imageController = ImageController(context: PersistenceController.shared.container.viewContext)
                    } else {
                        authController.isAuthenticated = false
                        GlobalState.shared.currentUser = nil
                    }
                } catch {
                    print("Failed to fetch auth session: \(error)")
                }
                isSessionChecked = true
            }
        }
    }
}
