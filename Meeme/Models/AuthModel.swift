import Amplify
import Combine

class AuthState: ObservableObject {
    @Published var isAuthenticated = false
    
    init() {
        _ = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
                case HubPayload.EventName.Auth.signedIn:
                    print("SIGNED IN BABY")
                    self.isAuthenticated = true
                case HubPayload.EventName.Auth.sessionExpired:
                    print("NOT SIGNED IN")
                    self.isAuthenticated = false
                case HubPayload.EventName.Auth.signedOut:
                    print("NOT SIGNED IN")
                    self.isAuthenticated = false
                case HubPayload.EventName.Auth.userDeleted:
                    print("NOT SIGNED IN")
                    self.isAuthenticated = false
                default:
                    break
            }
        }
    }
}
