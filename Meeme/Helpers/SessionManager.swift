import Amplify

enum AuthState {
    case signUp
    case login
    case confirmCode(email: String)
    case session(user: AuthUser)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    
    func getCurrentAuthState() {
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
    
    func signUp(email: String, password: String) {
        let atributes = [AuthUserAttribute(.email, value: email)]
        _ = AuthSignUpRequest.Options(userAttributes: atributes)
        
        Amplify.Auth.signUp(username: email, password: password) {
            [weak self] result in switch result {
            case .success(let signUpResult):
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
    
    func login(email: String, password: String) {
        Amplify.Auth.signIn(username: email, password: password) {
            [weak self] result in switch result {
            case .success(let signInResult):
                print("Successfully signed in: ", signInResult)
                if (signInResult.isSignedIn) {
                    DispatchQueue.main.async {
                        self?.getCurrentAuthState()
                    }
                }
            case .failure(let error):
                print("Sign in error: ", error)
            }
        }
    }
    
    func signOut() {
        Amplify.Auth.signOut { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentAuthState()
                }
            case .failure(let error):
                print("Sign out error: ", error)
            }
        }
    }
}
