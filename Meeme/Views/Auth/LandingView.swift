import SwiftUI

struct LandingView: View {
    
    @EnvironmentObject var sessionModel: SessionModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("appBackground").edgesIgnoringSafeArea(.all)
                VStack {

                    NavigationLink(destination: SignUpView().toolbarRole(.editor).environmentObject(sessionModel)) {
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
                            Text("Log in with existing account")
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
        .navigationViewStyle(.stack)
    }
}
