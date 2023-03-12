import SwiftUI
import Amplify

struct SignInView: View {

    @EnvironmentObject var sessionModel: SessionModel
    
    enum Field {
        case email
        case password
    }

    @FocusState private var focusedField: Field?

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    @State private var isError: Bool = false
    @State private var isLoading: Bool = false
    @State private var hasForgotPassword: Bool = false

    
    private func handleSubmit() {
        if email.isEmpty {
            focusedField = .email
        } else if password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            isLoading = true
            Task {
                await signIn()
            }
        }
    }

    func signIn() async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            if signInResult.isSignedIn {
                await sessionModel.fetchAuthState()
            }
        } catch (let error as AuthError) {
            isError = true
            isLoading = false
            errorMessage = error.localizedDescription
        } catch {
            isError = true
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    
    
    var body: some View {
        ZStack {
            Color("appBackground").edgesIgnoringSafeArea(.all)
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
                    .submitLabel(.continue)
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
                        hasForgotPassword = true
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
                    dismissButton: .default(Text("Got it!")) {
                        isError = false
                        errorMessage = ""
                    }
                )
            }
            .sheet(item: $hasForgotPassword, content: )
        }
    }
}
