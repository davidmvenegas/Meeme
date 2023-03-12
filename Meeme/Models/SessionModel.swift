import Foundation
import Amplify
import AWSCognitoAuthPlugin


enum AuthState {
    case unauthenticated
    case session(user: AuthUser)
}


final class SessionModel: ObservableObject {
    @Published var authState: AuthState = .unauthenticated
    @Published var hasConfirmCode: Bool = false
    
    
    // FETCH AUTH STATE
    func fetchAuthState() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if session.isSignedIn {
                let user = try await Amplify.Auth.getCurrentUser()
                DispatchQueue.main.async {
                    self.authState = .session(user: user)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    // SIGN UP
    func signUp(firstName: String, lastName: String, email: String, password: String) async {
        let userAttributes = [
            AuthUserAttribute(.givenName, value: firstName),
            AuthUserAttribute(.familyName, value: lastName)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )
            if case let .confirmUser(details, _, _) = signUpResult.nextStep {
                print(details ?? "No details")
                DispatchQueue.main.async {
                    self.hasConfirmCode = true
                }
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    // CONFIRM SIGN UP
    func confirmSignUp(email: String, code: String) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: email,
                confirmationCode: code
            )
            if (confirmSignUpResult.isSignUpComplete) {
                self.hasConfirmCode = false
                await self.fetchAuthState()
            }
        } catch let error as AuthError {
            print("An error occurred while confirming sign up: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    // RESEND CONFIRMATION CODE
    func resendCode() async {
        do {
            let deliveryDetails = try await Amplify.Auth.resendConfirmationCode(forUserAttributeKey: .email)
            print("Resend code sent to - \(deliveryDetails)")
        } catch let error as AuthError {
            print("Resend code failed with error: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    // SIGN IN
    func signIn(email: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            if signInResult.isSignedIn {
                await self.fetchAuthState()
            }
        } catch let error as AuthError {
            print("An error occurred while signing in: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    // SIGN OUT
    func signOut() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        switch signOutResult {
        case .complete:
            await self.fetchAuthState()

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            if (hostedUIError != nil) {print("HostedUI error: \(String(describing: hostedUIError))")}
            if globalSignOutError != nil {print("GlobalSignOut error: \(String(describing: globalSignOutError))")}
            if revokeTokenError != nil {print("Revoke token error: \(String(describing: revokeTokenError))")}

        case .failed(let error):
            print("SignOut failed with error: \(error)")
        }
    }
}
