import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            
            Button("Login", action: {})
            Spacer()
            Button("Don't have an account? Sign up.", action: {})
        }
        .padding()
    }
}
