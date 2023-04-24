// swiftlint:disable all
import Amplify
import Foundation

public struct AlbumMeeme: Model {
  public let id: String
  public var album: Album
  public var meeme: Meeme
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      album: Album,
      meeme: Meeme) {
    self.init(id: id,
      album: album,
      meeme: meeme,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      album: Album,
      meeme: Meeme,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.album = album
      self.meeme = meeme
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}