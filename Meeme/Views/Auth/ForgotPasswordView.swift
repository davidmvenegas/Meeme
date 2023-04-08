import Amplify
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = ""
    @State private var isEmailFocused: Bool = false
    @State private var confirmationMessage: String = ""
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMessage: String = ""
    
    private func handleResetPassword() {
        if email.isEmpty {
            isEmailFocused = true
        } else {
            isEmailFocused = false
            isLoading = true
            Task {
                await resetPassword()
            }
        }
    }

    func resetPassword() async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: email)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    confirmationMessage = "Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))"
                case .done:
                    print("Reset completed")
            }
        } catch let error as AuthError {
            isError = true
            isLoading = false

            switch error.errorDescription {
                default:
                    print("Unexpected error: \(error.errorDescription)")
                    errorMessage = "Unexpected error occurred"
            }

        } catch {
            isError = true
            isLoading = false
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
                
                TextField("Email", text: $email, onEditingChanged: { focused in
                    isEmailFocused = focused
                })
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .submitLabel(.send)
                .padding()
                .cornerRadius(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(isEmailFocused ? Color.blue : Color(UIColor.systemGray4), lineWidth: 2)
                }
                
                Button(action: handleResetPassword) {
                    HStack(spacing: 10) {
                        Text("Send Reset Link")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, minHeight: 35)
                }
                .padding(.top, 16)
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .onSubmit(handleResetPassword)
            .disabled(isLoading)
            .alert(isPresented: $isError) {
                Alert(
                    title: Text(errorMessage),
                    dismissButton: .default(Text("OK")) {
                        isError = false
                        errorMessage = ""
                    }
                )
            }
        }
        .onAppear {
            isEmailFocused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
