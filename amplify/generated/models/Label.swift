// swiftlint:disable all
import Amplify
import Foundation

public struct Label: Embeddable {
  var name: String
  var type: String
  var confidence: Double?
}