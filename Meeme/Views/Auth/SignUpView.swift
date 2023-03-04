import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .textContentType(.emailAddress)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
            
            Button("Sign Up", action: {
                sessionManager.signUp(email: email, password: password)
            })
            
            Spacer()
            
            Button("Already have an account? Log in.", action: {
                sessionManager.showLogin()
            })
        }
        .padding()
    }
}
