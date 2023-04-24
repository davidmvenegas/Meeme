// swiftlint:disable all
import Amplify
import Foundation

extension Label {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case name
    case type
    case confidence
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let label = Label.keys
    
    model.pluralName = "Labels"
    
    model.fields(
      .field(label.name, is: .required, ofType: .string),
      .field(label.type, is: .required, ofType: .string),
      .field(label.confidence, is: .optional, ofType: .double)
    )
    }
}