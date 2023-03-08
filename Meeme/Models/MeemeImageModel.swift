import Foundation
import SwiftUI

struct MeemeImage: Identifiable {
    let id = UUID()
    let url: String
}

extension MeemeImage: Equatable {
    static func ==(lhs: MeemeImage, rhs: MeemeImage) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}

class ImageModel: ObservableObject {
    
    @Published var meemeImagesArray: [MeemeImage] = []
    
    init() {
        for _ in 1..<50 {
            let mImage = MeemeImage(url: "https://picsum.photos/600")
            meemeImagesArray.append(mImage)
        }
    }
    
    func addImage(_ mImage: MeemeImage) {
        meemeImagesArray.insert(mImage, at: 0)
    }
    
    func removeImage(_ mImage: MeemeImage) {
        if let index = meemeImagesArray.firstIndex(of: mImage) {
            meemeImagesArray.remove(at: index)
        }
    }
}
