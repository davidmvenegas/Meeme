// swiftlint:disable all
import Amplify
import Foundation

extension Meeme {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case user
    case timestamp
    case labels
    case url
    case localUrl
    case albumMeemes
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
      .index(fields: ["ownerId"], name: "byUser"),
      .primaryKey(fields: [meeme.id])
    )
    
    model.fields(
      .field(meeme.id, is: .required, ofType: .string),
      .belongsTo(meeme.user, is: .required, ofType: User.self, targetNames: ["ownerId"]),
      .field(meeme.timestamp, is: .required, ofType: .string),
      .field(meeme.labels, is: .required, ofType: .embeddedCollection(of: Label.self)),
      .field(meeme.url, is: .required, ofType: .string),
      .field(meeme.localUrl, is: .optional, ofType: .string),
      .hasMany(meeme.albumMeemes, is: .optional, ofType: AlbumMeeme.self, associatedWith: AlbumMeeme.keys.meeme),
      .field(meeme.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(meeme.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Meeme: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}