//
//  HTTPClient.swift

import Foundation

protocol HTTPClient {
  func sendRequest(endpoint: Endpoint, followRedirections: Bool) async throws -> String
  func sendRequest<T: Decodable>(endpoint: Endpoint,followRedirections: Bool, responseModel: T.Type) async throws -> T
}

class DefaultHTTPClient: NSObject, HTTPClient {

  func sendRequest(
    endpoint: Endpoint,
    followRedirections: Bool
  ) async throws -> String {
    try await sendRequest(endpoint: endpoint, followRedirections: followRedirections, responseModel: String.self)
  }

  func sendRequest<T: Decodable>(
    endpoint: Endpoint,
    followRedirections: Bool,
    responseModel: T.Type
  ) async throws -> T {
    let request = try endpoint.makeRequest()
    let customDelegate = CustomSessionTaskDelegate(followRedirections: followRedirections)

    guard let (data, response) = try? await URLSession.shared.data(for: request, delegate: customDelegate) else {
      throw NetworkError.unknownNetworkError(request: request)
    }
    guard let response = response as? HTTPURLResponse else {
      throw NetworkError.apiNoResponse(request: request)
        .alsoLogWarning()
    }

    let operationInfo = HttpOperationInfo(request: request, response: response, responseData: data)

    switch response.statusCode {
    case 100...299:
      // success
      if responseModel == String.self {
        Logger.service(operationInfo)
        return String(bytes: data, encoding: .utf8) as! T
      } else {
        guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
          throw NetworkError.errorDecodingAPIResponse(info: operationInfo)
            .alsoLogWarning()
        }

        Logger.service(operationInfo)
        return decodedResponse
      }
    case 300...399:
      // redirection
      guard let locationHeader = response.allHeaderFields["Location"] as? String else {
        throw NetworkError.badResponse(info: operationInfo)
          .alsoLogWarning()
      }
      guard responseModel == String.self else {
        throw NetworkError.expectedString(info: operationInfo)
          .alsoLogWarning()
      }

      Logger.service(operationInfo)
      return locationHeader as! T
    case 400...499:
      // client error
      throw NetworkError.generic(info: operationInfo).alsoLogWarning()
    case 500...599:
      // server error
      throw NetworkError.generic(info: operationInfo).alsoLogWarning()
    default:
      throw NetworkError.generic(info: operationInfo).alsoLogWarning()
    }
  }
}

