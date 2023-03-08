import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var email = ""
    @State var password = ""
    
    
    var body: some View {
        VStack {
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .textContentType(.username)
                .keyboardType(.emailAddress)
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
            
            Button("Login", action: {
                sessionManager.login(email: email, password: password)
            })
            
        }
        .padding()

    }
}
