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
        
        @State private var isSessionChecked = false

        var body: some View {
            if !isSessionChecked {
                ProgressView()
                    .onAppear(perform: checkSession)
            } else if authState.isAuthenticated {
                HomeView()
                    .environmentObject(authState)
                    .environmentObject(imageModel)
            } else {
                LandingView()
                    .environmentObject(authState)
            }
        }

        private func checkSession() {
            Task {
                do {
                    let session = try await Amplify.Auth.fetchAuthSession()
                    if (session.isSignedIn) {
                        print("SIGNED IN BABY")
                        authState.isAuthenticated = true
                    } else {
                        print("NOT SIGNED IN")
                        authState.isAuthenticated = false
                    }
                } catch {
                    print("Failed to fetch auth session: \(error)")
                }
                isSessionChecked = true
            }
        }
    }
}
