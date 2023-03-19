import SwiftUI
import Amplify

struct ForgotPassword: View {

    @State private var email: String = ""
    @State private var errorMessage: String = ""
    @State private var confirmationMessage: String = ""

    func resetPassword(username: String) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    confirmationMessage = "Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))"
                case .done:
                    print("Reset completed")
            }
        } catch let error as AuthError {
            switch error {
                case .service(let errorDescription, _, _):
                    errorMessage = errorDescription
                default:
                    errorMessage = "Unexpected error occurred"
            }
        } catch {
            errorMessage = "Unexpected error occurred"
        }
    }

    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 35)
            Text("Enter your email address to reset your password")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 15)
                .padding(.bottom, 25)
            TextField("Email", text: .constant(""))
                .padding()
                .background(Color("textFieldBackground"))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {Task {await resetPassword(username: email)}}) {
                Text("Reset Password")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(5.0)
            .padding(.bottom, 25)
            HStack {
                Text("Remember your password?")
                    .font(.body)
                    .foregroundColor(.gray)
                Button(action: {}) {
                    Text("Sign In")
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
