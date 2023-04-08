import Amplify
import SwiftUI

struct SignInView: View {
    enum Field {
        case email
        case password
    }

    @FocusState private var focusedField: Field?

    @State private var email: String = ""
    @State private var password: String = ""

    @State private var isError: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""

    @State private var showForgotPasswordSheet: Bool = false

    private func handleSubmit() {
        if email.isEmpty {
            focusedField = .email
        } else if password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            isLoading = true
            Task {
                await handleSignIn()
            }
        }
    }

    func handleSignIn() async {
        do {
            _ = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )

        } catch let error as AuthError {
            isError = true
            isLoading = false
            switch error.errorDescription {
                case "User does not exist.":
                    errorMessage = "An account with this email does not exist"
                case "Incorrect username or password.":
                    errorMessage = "Password is incorrect"
                default:
                    errorMessage = "An unexpected error occurred"
            }
        } catch {
            isError = true
            isLoading = false
            errorMessage = "An unexpected error occurred"
        }
    }

    var body: some View {
        ZStack {
            Color("appBackground").edgesIgnoringSafeArea(.all)
            ScrollView {
                Rectangle()
                    .frame(height: 200)
                    .opacity(0)
                VStack(spacing: 20) {
                    Spacer()

                    TextField("Email", text: $email)
                        .textContentType(.username)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .onSubmit { focusedField = .password }
                        .submitLabel(.next)
                        .padding()
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(focusedField == .email ? Color.blue : Color(UIColor.systemGray4), lineWidth: 2)
                        }

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .onSubmit { focusedField = nil }
                        .submitLabel(.go)
                        .padding()
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(focusedField == .password ? Color.blue : Color(UIColor.systemGray4), lineWidth: 2)
                        }

                    Text("Forgot Password?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .padding(.bottom, 18)
                        .onTapGesture {
                            showForgotPasswordSheet = true
                        }

                    Button(action: handleSubmit) {
                        HStack(spacing: 10) {
                            Text("Sign in")
                                .font(.headline)
                            if isLoading {
                                ProgressView()
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .padding()
                .navigationTitle("Sign In")
                .navigationViewStyle(.stack)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .onSubmit(handleSubmit)
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
                .sheet(isPresented: $showForgotPasswordSheet) {
                    ForgotPasswordView()
                }
            }
        }
        .onAppear {
            focusedField = .email
        }
    }
}
