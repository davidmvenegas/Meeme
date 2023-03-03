import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var code = ""
    
    let email: String
    
    var body: some View {
        VStack {
            Text("email: \(email)")
            
            TextField("Confirmation Code", text: $code)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
            
            Button("Confirm", action: {
                sessionManager.confirm(
                    email: email,
                    code: code
                )
            })
        }
        .padding()
    }
}
