//
//  Endpoint.swift

import Foundation

protocol Endpoint {
  var scheme: String { get }
  var host: String { get }
  var port: Int? { get }
  var path: String { get }
  var method: RequestMethod { get }
  var header: [String: String]? { get }
  var body: [String: Any]? { get }
  var bodyData: Data? { get }
  var queryParams: [String: String]? { get }
  func makeRequest() throws -> URLRequest
}

extension Endpoint {
  func makeRequest() throws -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = self.scheme
    urlComponents.host = self.host
    urlComponents.path = self.path

    if let port = self.port {
      urlComponents.port = port
    }

    if let params = self.queryParams {
      urlComponents.queryItems = params.map { item in
        return URLQueryItem(name: item.key , value: item.value)
      }
    }

    urlComponents.normalizePercentEncodedQuery()

    guard let url = urlComponents.url else {
      throw NetworkError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = self.method.rawValue
    request.allHTTPHeaderFields = self.header

    if let body = self.body {
      if header?.containsAll(HTTPHeaders.url) ?? false {
        var urlComponents = URLComponents()
        urlComponents.queryItems = body.map {
          URLQueryItem(name: $0.key, value: "\($0.value)")
        }

        urlComponents.normalizePercentEncodedQuery()

        request.httpBody = urlComponents.percentEncodedQuery?.toUtf8Data()
      } else {
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) {
          request.httpBody = jsonData
        }
      }
    }
    
    if let bodyData {
      request.httpBody = bodyData
    }
    return request
  }
}

