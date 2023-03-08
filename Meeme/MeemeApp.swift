import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct MeemeApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @StateObject var imageModel = ImageModel()
    
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthState()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .unauthenticated:
                LandingView()
                    .environmentObject(sessionManager)
            case .confirmCode(let email):
                ConfirmationView(email: email)
                    .environmentObject(sessionManager)
            case .session(let user):
                HomeView(user: user)
                    .environmentObject(sessionManager)
                    .environmentObject(imageModel)
                    .navigationViewStyle(.stack)
            }
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured successfully")
        } catch {
            print("Could not initialize Amplify: ", error)
        }
    }
}
