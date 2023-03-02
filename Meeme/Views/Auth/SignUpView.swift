import SwiftUI

struct SignUpView: View {
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: $username)
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            
            Button("Sign Up", action: {})
            Spacer()
            Button("Already have an account? Log in.", action: {})
        }
        .padding()
    }
}
