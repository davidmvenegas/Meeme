import Amplify
import Combine
import Foundation


class AuthController: ObservableObject {
    @Published var isAuthenticated = false

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
}
