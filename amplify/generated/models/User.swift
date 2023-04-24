// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var meemes: List<Meeme>?
  public var albums: List<Album>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      meemes: List<Meeme>? = [],
      albums: List<Album>? = []) {
    self.init(id: id,
      meemes: meemes,
      albums: albums,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      meemes: List<Meeme>? = [],
      albums: List<Album>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.meemes = meemes
      self.albums = albums
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}