import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import SwiftUI

@main
struct MeemeApp: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
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

        var body: some View {
            if !authController.isSessionChecked {
                ProgressView()
                    .onAppear(perform: authController.checkSession)
            } else if authController.isAuthenticated {
                HomeView()
                    .environmentObject(authController)
            } else {
                LandingView()
                    .environmentObject(authController)
            }
        }
    }
}
