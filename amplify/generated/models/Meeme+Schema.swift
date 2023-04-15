// swiftlint:disable all
import Amplify
import Foundation

extension Meeme {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case ownerId
    case timestamp
    case labels
    case imageUrl
    case localImageUrl
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let meeme = Meeme.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Meemes"
    
    model.attributes(
      .primaryKey(fields: [meeme.id])
    )
    
    model.fields(
      .field(meeme.id, is: .required, ofType: .string),
      .field(meeme.ownerId, is: .required, ofType: .string),
      .field(meeme.timestamp, is: .required, ofType: .string),
      .field(meeme.labels, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(meeme.imageUrl, is: .required, ofType: .string),
      .field(meeme.localImageUrl, is: .optional, ofType: .string),
      .field(meeme.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(meeme.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Meeme: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}