import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionModel: SessionModel
    @State private var code: String = ""
    var email: String = ""
    
    
    var body: some View {
        ZStack {
            Color("appBackground").edgesIgnoringSafeArea(.all)
            VStack {
                Text("email: \(email)")
                
                TextField("Confirmation Code", text: $code)
                    .padding()
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                    }
                
                Button("Confirm", action: {
                    Task {
                        await sessionModel.confirmSignUp(
                            email: email,
                            code: code
                        )
                    }
                })
            }
            .padding()
        }
    }
}
