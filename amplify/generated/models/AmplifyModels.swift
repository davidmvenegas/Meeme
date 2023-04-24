// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "cb0d0e4b3df004925559367b011382df"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Album.self)
    ModelRegistry.register(modelType: Meeme.self)
    ModelRegistry.register(modelType: AlbumMeeme.self)
  }
}