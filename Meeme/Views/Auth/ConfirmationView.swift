import SwiftUI

struct ConfirmationView: View {
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Text("Username: \(username)")
            TextField("Confirmation Code", text: $confirmationCode)
            Button("Sign Up", action: {})
        }
        .padding()
    }
}
