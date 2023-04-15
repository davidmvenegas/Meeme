import Amplify
import SwiftUI

struct MeemeImage: Identifiable {
    let id: String
    let key: String
    let url: URL
    let labels: String
    let ownerId: String
}

class ImageController: ObservableObject {
    let authController: AuthController
    @Published var meemeImages: [MeemeImage] = []

    init(authController: AuthController) {
        self.authController = authController
    }

    // Get user details

    func uploadImage(imageData: Data) async -> Bool {
        do {
            let ownerId = authController.currentUser[.sub]!
            let timestamp = String(DateService.createTimestamp())
            let uploadTask = Amplify.Storage.uploadData(
                key: "\(ownerId)_\(timestamp)",
                data: imageData
            )
            _ = try await uploadTask.value
            return true
        } catch {
            return false
        }
    }
}
