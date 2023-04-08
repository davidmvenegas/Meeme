import Amplify
import Combine
import Foundation

class AuthController: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isSessionChecked = false
    @Published var currentUser: AuthUser?

    init() {
        _ = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
                case HubPayload.EventName.Auth.signedIn:
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                case HubPayload.EventName.Auth.sessionExpired,
                     HubPayload.EventName.Auth.signedOut,
                     HubPayload.EventName.Auth.userDeleted:
                    DispatchQueue.main.async {
                        self.isAuthenticated = false
                    }
                default:
                    break
            }
        }
    }

    public func checkSession() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                if session.isSignedIn {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                    currentUser = try await Amplify.Auth.getCurrentUser()
                } else {
                    DispatchQueue.main.async {
                        self.isAuthenticated = false
                    }
                }
            } catch {
                print("Failed to fetch auth session: \(error)")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
            DispatchQueue.main.async {
                self.isSessionChecked = true
            }
        }
    }
}
