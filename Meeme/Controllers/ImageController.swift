import SwiftUI
import Vision
import Amplify
import CoreData


struct MeemeImage: Identifiable {
    let id: String
    let key: String
    let url: URL?
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

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.loadMeemeImages()
    }


    func loadMeemeImages() {
        do {
            let currentUserId = GlobalState.shared.currentUser!.userId
            let fetchRequest: NSFetchRequest<MeemeImageEntity> = MeemeImageEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ownerId == %@", currentUserId)
            let results = try context.fetch(fetchRequest)
            for result in results {
                let meemeImage = MeemeImage(
                    id: result.id!,
                    key: result.key!,
                    url: result.url != nil ? URL(string: result.url!) : nil,
                    labels: result.labels!,
                    ownerId: result.ownerId!
                )
                self.meemeImages.append(meemeImage)
            }
        } catch {
            print("Error loading meeme images: \(error.localizedDescription)")
        }
    }


    func uploadMeemeImage(imageData: Data, ownerId: String) async {
        do {
            guard let ciImage = CIImage(data: imageData),
                  let orientation = CGImagePropertyOrientation(rawValue: UInt32(ciImage.properties["Orientation"] as? Int ?? 1))
            else {
                print("Error processing image")
                return
            }

            let textRequest = VNRecognizeTextRequest { request, error in
                DispatchQueue.main.async {
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        print("Error recognizing text: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    let timestamp = String(DateFormater.createTimestamp())
                    
                    let labels = observations.compactMap { observation in
                        return observation.topCandidates(1).first?.string
                    }
                    
                    guard let uiImage = UIImage(data: imageData),
                          let imageUrl = self.saveImageToDisk(image: uiImage, imageName: "\(timestamp).jpeg")
                    else {
                        print("Error saving image to disk")
                        return
                    }
                    
                    let newImage = MeemeImage(
                        id: UUID().uuidString,
                        key: timestamp,
                        url: imageUrl,
                        labels: labels.joined(separator: ", "),
                        ownerId: ownerId
                    )

                    let meemeImageEntity = MeemeImageEntity(context: self.context)
                    meemeImageEntity.id = newImage.id
                    meemeImageEntity.key = newImage.key
                    meemeImageEntity.url = newImage.url?.absoluteString
                    meemeImageEntity.labels = newImage.labels
                    meemeImageEntity.ownerId = newImage.ownerId

                    self.meemeImages.append(newImage)
                    self.saveMeemeImages()
                }
            }

            let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation, options: [:])
            try imageRequestHandler.perform([textRequest])
        } catch {
            print("Error processing image: \(error.localizedDescription)")
        }
    }
    
    
    func saveImageToDisk(image: UIImage, imageName: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsDirectory.appendingPathComponent(imageName)

        do {
            try image.jpegData(compressionQuality: 1.0)?.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("Error saving image to disk: \(error.localizedDescription)")
            return nil
        }
    }


    func saveMeemeImages() {
        for meemeImage in meemeImages {
            let meemeImageEntity = MeemeImageEntity(context: context)
            meemeImageEntity.id = meemeImage.id
            meemeImageEntity.key = meemeImage.key
            meemeImageEntity.url = meemeImage.url?.absoluteString
            meemeImageEntity.labels = meemeImage.labels
            meemeImageEntity.ownerId = meemeImage.ownerId
        }
        do {
            try context.save()
        } catch {
            print("Error saving meeme images: \(error.localizedDescription)")
        }
    }
}
