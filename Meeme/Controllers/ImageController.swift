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
    @Published var meemeImages: [MeemeImage] = []

    func uploadImage(imageData: Data) async -> Bool {
        do {
            let timestamp = String(DateService.createTimestamp())
            let uploadTask = Amplify.Storage.uploadData(
                key: timestamp,
                data: imageData
            )
            _ = try await uploadTask.value
            return true
        } catch {
            return false
        }
    }
}
