import Foundation
import Amplify
import AWSCognitoAuthPlugin

enum AuthState {
    case unauthenticated
    case authenticated
}

final class SessionModel: ObservableObject {
    @Published var authState: AuthState = .unauthenticated

    func fetchAuthState() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if (session.isSignedIn) {
                DispatchQueue.main.async { self.authState = .authenticated }
            } else {
                DispatchQueue.main.async { self.authState = .unauthenticated }
            }
        } catch {
            print(error)
        }
    }
}
