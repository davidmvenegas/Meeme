import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct MeemeApp: App {
    
    @ObservedObject var sessionManager = SessionManger()
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
            case .signUp:
                SignUpView()
            case .confirmCode(let username):
                ConfirmationView(username: username)
            case .session(let user):
                HomeView(user: user)
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
