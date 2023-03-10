import SwiftUI

struct LandingView: View {
    
    @EnvironmentObject var sessionModel: SessionModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    
                    Text("LANDING VIEW")
                        .padding()
                    
                    NavigationLink(destination: SignUpView().environmentObject(sessionModel)) {
                        Text("Continue with Email")
                    }
                    
                    Text("OR")
                        .padding()
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log in with existing account")
                    }
                }
            }
            .navigationTitle("Join Meeme")
        }
    }
}
