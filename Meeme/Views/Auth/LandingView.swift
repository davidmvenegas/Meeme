import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("appBackground").edgesIgnoringSafeArea(.all)
                ScrollView {
                    Rectangle()
                        .frame(height: 200)
                        .opacity(0)
                    VStack {
                        NavigationLink(destination: SignUpView().toolbarRole(.editor)) {
                            HStack(spacing: 10) {
                                Text("Continue with Email")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 35)
                        }
                        .buttonStyle(.borderedProminent)

                        Text("OR").padding()

                        NavigationLink(destination: SignInView().toolbarRole(.editor)) {
                            HStack(spacing: 10) {
                                Text("Sign in with existing account")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 35)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("grayButton"))
                    }
                    .navigationTitle("Join Meeme")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.horizontal)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
