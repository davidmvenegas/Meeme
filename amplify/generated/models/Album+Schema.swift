// swiftlint:disable all
import Amplify
import Foundation

extension Album {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case user
    case albumMeemes
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let album = Album.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Albums"
    
    model.attributes(
      .index(fields: ["ownerId"], name: "byUser"),
      .primaryKey(fields: [album.id])
    )
    
    model.fields(
      .field(album.id, is: .required, ofType: .string),
      .field(album.title, is: .required, ofType: .string),
      .belongsTo(album.user, is: .required, ofType: User.self, targetNames: ["ownerId"]),
      .hasMany(album.albumMeemes, is: .optional, ofType: AlbumMeeme.self, associatedWith: AlbumMeeme.keys.album),
      .field(album.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(album.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Album: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}