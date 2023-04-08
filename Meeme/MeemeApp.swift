import Amplify
import AWSCognitoAuthPlugin
import SwiftUI

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
        @ObservedObject var authController = AuthController()
        @State var isSessionChecked = false

        var body: some View {
            if !isSessionChecked {
                ProgressView()
                    .onAppear(perform: checkSession)
            } else if authController.isAuthenticated {
                HomeView()
                    .environmentObject(authController)
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
//                        try await Amplify.Auth.getCurrentUser()
                    } else {
                        authController.isAuthenticated = false
                    }
                } catch {
                    print("Failed to fetch auth session: \(error)")
                    authController.isAuthenticated = false
                }

                isSessionChecked = true
            }
        }
    }
}
