import Amplify

enum AuthState {
    case signUp
    case login
    case confirmCode(email: String)
    case session(user: AuthUser)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
        } else {
            authState = .login
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }

    func showLogin() {
        authState = .login
    }
    
    func signUp(email: String, username: String, password: String) {
        let atributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: atributes)
        
        Amplify.Auth.signUp(username: username, password: password) {
            [weak self] result in switch result {

            case .success(let signUpResult):
                print("Sign up result: ", signUpResult)

                switch signUpResult.nextStep {
                case .done:
                    print("Finished signing up")
                case .confirmUser(let details, _):
                    print(details ?? "No details")

                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(email: email)
                    }
                }

            case .failure(let error):
                print("Sign up error: ", error)
            }
        }
    }
    
    func confirm(email: String, code: String) {
        Amplify.Auth.confirmSignUp(for: email, confirmationCode: code) {
            [weak self] result in switch result {
                
            case .success(let confirmResult):
                print("Code successfully confirmed: ", confirmResult)
                if (confirmResult.isSignupComplete) {
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
                
            case .failure(let error):
                print("Failed to confirm code: ", error)
            }
        }
    }
}
