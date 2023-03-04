import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct MeemeApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthState()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
            case .confirmCode(let email):
                ConfirmationView(email: email)
                    .environmentObject(sessionManager)
            case .session(let user):
                HomeView(user: user)
                    .environmentObject(sessionManager)
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
