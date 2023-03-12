import SwiftUI


struct SignInView: View {
    
    @EnvironmentObject var sessionModel: SessionModel
    
    enum Field {
        case email
        case password
    }

    @FocusState private var focusedField: Field?

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    
    private func handleSubmit() {
        if email.isEmpty {
            focusedField = .email
        } else if password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            isLoading = true
            Task {
                await sessionModel.signIn(
                    email: email,
                    password: password
                )
            }
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
        }
    }
}
