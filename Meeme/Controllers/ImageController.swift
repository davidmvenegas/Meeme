import SwiftUI
import Amplify
import CoreData


struct MeemeImage: Identifiable {
    let id: String
    let key: String
    let url: URL?
}

extension MeemeImage: Equatable {
    static func == (lhs: MeemeImage, rhs: MeemeImage) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}

class ImageController: ObservableObject {
    
    @Published var meemeImages: [MeemeImage] = []

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.loadMeemeImages()
    }
    
    func handleUploadMeemeToCloud(imageData: Data) async {
        do {
            let timestamp = String(DateFormater.createTimestamp())
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
            let url = try await Amplify.Storage.getURL(key: timestamp)
            let newImage = MeemeImage(id: UUID().uuidString, key: timestamp, url: url)
            self.meemeImages.append(newImage)
            self.saveMeemeImages()
        } catch {
            print(error)
        }
    }
    
    func loadMeemeImages() {
        do {
            let fetchRequest: NSFetchRequest<MeemeImageEntity> = MeemeImageEntity.fetchRequest()
            let results = try context.fetch(fetchRequest)
            for result in results {
                let meemeImage = MeemeImage(
                    id: result.id!,
                    key: result.key!,
                    url: result.url != nil ? URL(string: result.url!) : nil
                )
                self.meemeImages.append(meemeImage)
            }
        } catch {
            print("Error loading meeme images: \(error.localizedDescription)")
        }
    }


    
    func saveMeemeImages() {
        for meemeImage in meemeImages {
            let meemeImageEntity = MeemeImageEntity(context: context)
            meemeImageEntity.id = meemeImage.id
            meemeImageEntity.key = meemeImage.key
            meemeImageEntity.url = meemeImage.url?.absoluteString
        }
        do {
            try context.save()
        } catch {
            print("Error saving meeme images: \(error.localizedDescription)")
        }
    }
}
