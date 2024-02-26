//
//  URLComponents.swift

import Foundation

extension URLComponents {
  mutating func normalizePercentEncodedQuery() {
    self.percentEncodedQuery = self.percentEncodedQuery?
      .replacingOccurrences(of: ":", with: "%3A")
      .replacingOccurrences(of: "+", with: "%2B")
      .replacingOccurrences(of: "%20", with: "+")
      .replacingOccurrences(of: ",", with: "%2C")
      .replacingOccurrences(of: "$", with: "%24")
  }
}
