import SwiftUI
import Amplify


struct MeemeImage: Identifiable {
    let id = UUID()
    let url: URL
}

extension MeemeImage: Equatable {
    static func == (lhs: MeemeImage, rhs: MeemeImage) -> Bool {
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
    
    func handleUploadMeemeToCloud(imageData: Data) {
//        let timestamp = String(DateFormater.createTimestamp())
        
//        Amplify.Storage.uploadData(key: timestamp, data: imageData) { result in
//            switch result {
//            case .success(let uploadData):
//                print(uploadData)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        meemeImages.insert(mImage, at: 0)
    }
    
    
    
    func removeImage(mImage: MeemeImage) {
        if let index = meemeImages.firstIndex(of: mImage) {
            meemeImages.remove(at: index)
        }
    }
}
