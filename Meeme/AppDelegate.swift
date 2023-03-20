import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeemeImageModel") // replace "MeemeImageModel" with the name of your Core Data model file
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Pass the NSManagedObjectContext instance to the ImageModel class
        let imageService = ImageService(context: persistentContainer.viewContext)
        // Inject the ImageModel instance into your view hierarchy (e.g. via environmentObject)
        // ...
        return true
    }
}
