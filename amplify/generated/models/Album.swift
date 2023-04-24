// swiftlint:disable all
import Amplify
import Foundation

public struct Album: Model {
  public let id: String
  public var title: String
  public var user: User
  public var albumMeemes: List<AlbumMeeme>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String,
      user: User,
      albumMeemes: List<AlbumMeeme>? = []) {
    self.init(id: id,
      title: title,
      user: user,
      albumMeemes: albumMeemes,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String,
      user: User,
      albumMeemes: List<AlbumMeeme>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.user = user
      self.albumMeemes = albumMeemes
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}