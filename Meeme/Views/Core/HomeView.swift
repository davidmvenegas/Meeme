import SwiftUI
import Amplify

struct HomeView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        Text("HOME VIEW")
    }
}
