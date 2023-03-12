import SwiftUI

struct ForgotPassword: View {
    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 35)
            Text("Enter your email address to reset your password")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 15)
                .padding(.bottom, 25)
            TextField("Email", text: .constant(""))
                .padding()
                .background(Color("textFieldBackground"))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {}) {
                Text("Reset Password")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(5.0)
            .padding(.bottom, 25)
            HStack {
                Text("Remember your password?")
                    .font(.body)
                    .foregroundColor(.gray)
                Button(action: {}) {
                    Text("Sign In")
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
