// swiftlint:disable all
import Amplify
import Foundation

public struct Meeme: Model {
  public let id: String
  public var ownerId: String
  public var timestamp: String
  public var labels: [String]
  public var imageUrl: String
  public var localImageUrl: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      ownerId: String,
      timestamp: String,
      labels: [String] = [],
      imageUrl: String,
      localImageUrl: String? = nil) {
    self.init(id: id,
      ownerId: ownerId,
      timestamp: timestamp,
      labels: labels,
      imageUrl: imageUrl,
      localImageUrl: localImageUrl,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      ownerId: String,
      timestamp: String,
      labels: [String] = [],
      imageUrl: String,
      localImageUrl: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.ownerId = ownerId
      self.timestamp = timestamp
      self.labels = labels
      self.imageUrl = imageUrl
      self.localImageUrl = localImageUrl
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}