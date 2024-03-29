// swiftlint:disable all
import Amplify
import Foundation

public struct Meeme: Model {
  public let id: String
  public var user: User
  public var timestamp: String
  public var labels: [Label?]
  public var url: String
  public var localUrl: String?
  public var albumMeemes: List<AlbumMeeme>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      user: User,
      timestamp: String,
      labels: [Label?] = [],
      url: String,
      localUrl: String? = nil,
      albumMeemes: List<AlbumMeeme>? = []) {
    self.init(id: id,
      user: user,
      timestamp: timestamp,
      labels: labels,
      url: url,
      localUrl: localUrl,
      albumMeemes: albumMeemes,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      user: User,
      timestamp: String,
      labels: [Label?] = [],
      url: String,
      localUrl: String? = nil,
      albumMeemes: List<AlbumMeeme>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.user = user
      self.timestamp = timestamp
      self.labels = labels
      self.url = url
      self.localUrl = localUrl
      self.albumMeemes = albumMeemes
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}