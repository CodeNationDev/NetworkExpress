//
//  HTTPHeaders.swift


import Foundation

struct HTTPHeaders {
  static let json = ["Content-Type": "application/json"]
  static let url = ["Content-Type": "application/x-www-form-urlencoded"]
  static let textPlain = ["Content-Type": "text/plain"]
}
