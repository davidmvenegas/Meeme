// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "3e99c39254b3d4167a40e8eb15572046"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Meeme.self)
  }
}