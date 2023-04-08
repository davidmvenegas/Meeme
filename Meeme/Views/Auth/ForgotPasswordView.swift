import Amplify
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isEmailFocused: Bool

    @State private var email: String = ""
    @State private var isAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    
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
                case .confirmResetPasswordWithCode:
                    isAlert = true
                    isLoading = false
                    alertMessage = "Confirmation code sent to \(email)"
                case .done:
                    print("Reset completed")
            }
        } catch let error as AuthError {
            isAlert = true
            isLoading = false

            switch error.errorDescription {
                default:
                    print("Unexpected error: \(error.errorDescription)")
                    alertMessage = "Unexpected error occurred"
            }

        } catch {
            isAlert = true
            isLoading = false
            alertMessage = "Unexpected error occurred"
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
                .focused($isEmailFocused)
                
                Button(action: handleResetPassword) {
                    HStack(spacing: 10) {
                        Text("Send Reset Link")
                            .font(.headline)
                        if isLoading {
                            ProgressView()
                        }
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
            .alert(isPresented: $isAlert) {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        isAlert = false
                        alertMessage = ""
                    }
                )
            }
        }
        .onAppear {
            isEmailFocused = true
        }
    }
}
