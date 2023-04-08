import SwiftUI
import Vision
import Amplify
import CoreData


struct MeemeImage: Identifiable {
    let id: String
    let key: String
    let url: URL
    let labels: String
    let ownerId: String
}

extension MeemeImage: Equatable {
    static func == (lhs: MeemeImage, rhs: MeemeImage) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}

class ImageController: ObservableObject {
    
    @Published var meemeImages: [MeemeImage] = []

}
