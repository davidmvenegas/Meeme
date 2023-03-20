import Amplify
import Combine

class AuthState: ObservableObject {
    @Published var isAuthenticated = false
    
    init() {
        _ = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
                case HubPayload.EventName.Auth.signedIn:
                    self.isAuthenticated = true
                case HubPayload.EventName.Auth.sessionExpired:
                    self.isAuthenticated = false
                case HubPayload.EventName.Auth.signedOut:
                    self.isAuthenticated = false
                case HubPayload.EventName.Auth.userDeleted:
                    self.isAuthenticated = false
                default:
                    break
            }
        }
    }
}
