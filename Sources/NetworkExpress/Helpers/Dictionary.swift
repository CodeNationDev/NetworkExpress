//
//  Dictionary.swift

import Foundation

extension Dictionary {

  func contains(_ pair: (key: Key, value: Value)) -> Bool where Value: Equatable {
    self[pair.key] == pair.value
  }

  func containsAll(_ otherDic: [Key: Value]) -> Bool where Value: Equatable {
    otherDic.allSatisfy {
      self.contains($0)
    }
  }

}
