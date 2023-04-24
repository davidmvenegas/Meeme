// swiftlint:disable all
import Amplify
import Foundation

extension AlbumMeeme {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case album
    case meeme
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let albumMeeme = AlbumMeeme.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "album.ownerId", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .read, .update, .delete]),
      rule(allow: .owner, ownerField: "meeme.ownerId", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .read, .update, .delete])
    ]
    
    model.pluralName = "AlbumMeemes"
    
    model.attributes(
      .index(fields: ["albumId"], name: "byAlbum"),
      .index(fields: ["meemeId"], name: "byMeeme"),
      .primaryKey(fields: [albumMeeme.id])
    )
    
    model.fields(
      .field(albumMeeme.id, is: .required, ofType: .string),
      .belongsTo(albumMeeme.album, is: .required, ofType: Album.self, targetNames: ["albumId"]),
      .belongsTo(albumMeeme.meeme, is: .required, ofType: Meeme.self, targetNames: ["meemeId"]),
      .field(albumMeeme.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(albumMeeme.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension AlbumMeeme: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}