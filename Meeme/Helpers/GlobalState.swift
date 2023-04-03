import Amplify
import Foundation


class GlobalState: ObservableObject {
    static let shared = GlobalState()

    @Published var currentUser: AuthUser?
}
