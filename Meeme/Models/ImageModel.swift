import Foundation
import SwiftUI

struct MeemeImage: Identifiable {
    let id = UUID()
    let url: URL
}

extension MeemeImage: Equatable {
    static func ==(lhs: MeemeImage, rhs: MeemeImage) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}

class ImageModel: ObservableObject {
    
    @Published var meemeImages: [MeemeImage] = []
    
    init() {
        for _ in 1..<50 {
            meemeImages.append(MeemeImage(url: URL(string: "https://picsum.photos/600")!))
        }
    }
    
    func addImage(_ mImage: MeemeImage) {
        meemeImages.insert(mImage, at: 0)
    }
    
    func removeImage(_ mImage: MeemeImage) {
        if let index = meemeImages.firstIndex(of: mImage) {
            meemeImages.remove(at: index)
        }
    }
}
