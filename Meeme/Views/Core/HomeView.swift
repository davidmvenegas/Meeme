import SwiftUI
import Amplify

struct HomeView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        VStack {
            Spacer()
            Text("HOME VIEW")
            Spacer()
            Button("Sign Out", action: sessionManager.signOut)
        }
    }
}
