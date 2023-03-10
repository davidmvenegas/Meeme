import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import AWSAPIPlugin

@main
struct MeemeApp: App {
    
    @StateObject var sessionModel = SessionModel()
    @StateObject var imageModel = ImageModel()
    
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured successfully")
        } catch {
            print("Could not initialize Amplify: ", error)
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            VStack {
                switch sessionModel.authState {
                case .unauthenticated:
                    LandingView()
                        .environmentObject(sessionModel)
                case .confirmCode(let email):
                    ConfirmationView(email: email)
                        .environmentObject(sessionModel)
                case .session(let user):
                    HomeView(user: user)
                        .environmentObject(sessionModel)
                        .environmentObject(imageModel)
                }
            }
            .task {
                await sessionModel.fetchAuthState()
            }
        }
    }
    
    
    private func configureAmplify() {
        
    }
}
