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
        configureAmplify()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch sessionModel.authState {
                case .unauthenticated:
                    LandingView()
                        .environmentObject(sessionModel)
                case .authenticated:
                    HomeView()
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
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured successfully")
        } catch {
            print(error)
        }
    }
}
