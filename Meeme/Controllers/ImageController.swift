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

    func uploadImageToCloud(imageData: Data) async {
        do {
            let timestamp = String(DateFormatter.createTimestamp())
            let uploadTask = Amplify.Storage.uploadData(
                key: timestamp,
                data: imageData
            )
            Task {
                for await progress in await uploadTask.progress {
                    print("Progress: \(progress)")
                }
            }
            let value = try await uploadTask.value
            print("Upload completed: \(value)")
        } catch {
            print(error)
        }
    }
}
