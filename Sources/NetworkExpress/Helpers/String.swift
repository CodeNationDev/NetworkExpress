//
//  Helpers+String.swift

import Foundation

/// Extension of String type for add new features.
extension String {

  /// Func for obtain url components from a baseURL provided by front.
  /// - Returns: triplet with schema, port and host components.
  func getURLComponents() -> (scheme: String, port: Int, host: String) {
    var components: (scheme: String, port: Int, host: String) = ("",0,"")

    let urlComponents = URLComponents(string: self)

    if let schema = urlComponents?.scheme  {
      components.scheme = schema
    }
    if let port = urlComponents?.port  {
      components.port = port
    }
    if let host = urlComponents?.host {
      components.host = host
    }
    return components
  }

  /// Func for obtain schema url component from a baseURL provided by front.
  /// - Returns: String with result or empty.
  func getURLSchema() -> String {
    URLComponents(string: self)?.scheme ?? ""
  }

  /// Func for obtain host url component from a baseURL provided by front.
  /// - Returns: String with result or empty.
  func getURLHost() -> String {
    URLComponents(string: self)?.host ?? ""
  }

  /// Func for obtain port url component from a baseURL provided by front.
  /// - Returns: Int with result or empty.
  func getURLPort() -> Int {
    URLComponents(string: self)?.port ?? 0
  }

  /// Func for obtain path url component from a baseURL provided by front.
  /// - Returns: String with result or empty.
  func getURLPath() -> String {
    URLComponents(string: self)?.path ?? ""
  }

  /// Func for obtain path url component from a baseURL provided by front.
  /// - Returns: String with result or empty.
  func getURLQueryItems() -> [String: String]? {
    URLComponents(string: self)?.queryItems?.reduce(into: [:], { params, item in
      params[item.name] = item.value
    })

  }

  /// Extension function for convert string to Data
  /// - Returns: Data stream bytes.
  func toUtf8Data() -> Data {
    Data(self.utf8)
  }
  
  /// Function for evaluate dates.
  /// - Returns: Optional boolean with eval result or nil if date format is wrong.
  func isExpired(dateFormat: String) -> Bool? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    if let date = dateFormatter.date(from: self) {
      let currentDate = Date()

      if date < currentDate {
        return true
      } else if date > currentDate {
        return false
      } else {
        return false
      }
    } else {
      return nil
    }
  }
}
