import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    
    let email: String
    
    var body: some View {
        VStack {
            Text("email: \(email)")
            TextField("Confirmation Code", text: $confirmationCode)
            Button("Sign Up", action: {})
        }
        .padding()
    }
}
