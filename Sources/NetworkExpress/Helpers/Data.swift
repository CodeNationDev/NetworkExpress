//
//  Data.swift

import Foundation

extension Data {


  /// Extension function for transform Data to String
  /// - Returns: String decoded from Data.
  func toUtf8String() -> String {
    String.init(decoding: self, as: UTF8.self)
  }
}
