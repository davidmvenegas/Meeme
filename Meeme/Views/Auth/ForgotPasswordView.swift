import Amplify
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isFocused: Bool

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
        ZStack {
            Color("appBackground").edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Text("Reset your password")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 10)
                .padding(.bottom, 25)
                
                Text("Enter the email address associated with your account, and we'll email you a link to reset your password")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 30)
                
                TextField("Email", text: $email)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .focused($isFocused)
                    .submitLabel(.send)
                    .padding()
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(isFocused ? Color.blue : Color(UIColor.systemGray4), lineWidth: 2)
                    }
                
                Button(action: {}) {
                    HStack(spacing: 10) {
                        Text("Send Reset Link")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, minHeight: 35)
                }
                .padding(.top, 16)
                .buttonStyle(.borderedProminent)
                .tint(email.isEmpty ? Color(UIColor.systemGray4) : Color.blue)
                
                Spacer()
            }
            .padding()
        }
    }
}
