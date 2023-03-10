import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionModel: SessionModel
    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("First Name", text: $firstName)
                .autocorrectionDisabled(true)
                .textContentType(.givenName)
                .keyboardType(.namePhonePad)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
            
            TextField("Last Name", text: $lastName)
                .autocorrectionDisabled(true)
                .textContentType(.familyName)
                .keyboardType(.namePhonePad)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
            
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
                .textContentType(.newPassword)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
            
            Button("Sign Up", action: {
                Task {
                    await sessionModel.signUp(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password
                    )
                }
            })
            
            Spacer()
            
            NavigationLink(destination: LoginView().environmentObject(sessionModel)) {
                Text("Log in with existing account")
            }
        }
        .padding()
    }
}
