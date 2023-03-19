import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import AWSAPIPlugin

@main
struct MeemeApp: App {

    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
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
        @ObservedObject var authState = AuthState()
        @ObservedObject var imageModel = ImageModel()

        var body: some View {
            if authState.isAuthenticated {
                HomeView()
                    .environmentObject(authState)
                    .environmentObject(imageModel)
            } else {
                LandingView()
                    .environmentObject(authState)
            }
        }
    }
}
