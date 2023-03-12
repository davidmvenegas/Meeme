import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionModel: SessionModel

    init(sessionModel: SessionModel) {
        _hasConfirmCode = State(initialValue: sessionModel.hasConfirmCode)
    }
    
    enum Field {
        case firstName
        case lastName
        case email
        case password
    }
    
    @FocusState private var focusedField: Field?
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoading: Bool = false
    @State private var hasConfirmCode: Bool

    
    private func handleSubmit() {
        if firstName.isEmpty {
            focusedField = .firstName
        } else if lastName.isEmpty {
            focusedField = .lastName
        } else if email.isEmpty {
            focusedField = .email
        } else if password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            isLoading = true
            Task {
                await sessionModel.signUp(
                    firstName: firstName,
                    lastName: lastName,
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
                
                HStack(spacing: 14) {
                    TextField("First Name", text: $firstName)
                        .textContentType(.givenName)
                        .keyboardType(.namePhonePad)
                        .focused($focusedField, equals: .firstName)
                        .onSubmit { focusedField = .lastName }
                        .submitLabel(.next)
                        .padding()
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(focusedField == .firstName ? Color.blue : Color(UIColor.systemGray4), lineWidth: 2)
                        }
                    TextField("Last Name", text: $lastName)
                        .textContentType(.familyName)
                        .keyboardType(.namePhonePad)
                        .focused($focusedField, equals: .lastName)
                        .onSubmit { focusedField = .email }
                        .submitLabel(.next)
                        .padding()
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(focusedField == .lastName ? Color.blue : Color(UIColor.systemGray4), lineWidth: 2)
                        }
                }
                
                TextField("Email", text: $email)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
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
                    .textInputAutocapitalization(.never)
                    .textContentType(.newPassword)
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
                        Text("Sign up")
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
            .navigationTitle("Sign Up")
            .navigationViewStyle(.stack)
            .autocorrectionDisabled(true)
            .onSubmit(handleSubmit)
            .disabled(isLoading)
            .sheet(isPresented: $hasConfirmCode) {
                print("Sheet dismissed!")
            } content: {
                ConfirmationView(email: email)
                    .environmentObject(sessionModel)
            }
        }
    }
}

@ViewBuilder
    func secureField() -> some View {
        
    }
