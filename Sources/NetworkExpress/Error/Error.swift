// NetworkExpress

import Foundation

/// Enum for join all triggered errors about Networking.
public enum NetworkError: Error, Equatable, HasAlso {
  case dummyError
  case badResponse(info: HttpOperationInfo)
  case generic(info: HttpOperationInfo)
  case errorDecodingAPIResponse(info: HttpOperationInfo)
  case expectedString(info: HttpOperationInfo)
  case unknownNetworkError(request: URLRequest)
  case apiNoResponse(request: URLRequest)
  case invalidURL
  
  public var description: String {
    let format = "###############\n%@:\n%@"
    let description: String
    switch self {
    case .dummyError:
      description = "Dummy Error"
    case let .generic(info):
      description = String(format: format, "Generic Error", info.description)
    case let .badResponse(info):
      description = String(format: format, "Bad Request", info.description)
    case .errorDecodingAPIResponse(info: let info):
      description = String(format: format, "Error parsing response", info.description)
    case .expectedString(info: let info):
      description = String(format: format, "Response expected as String format", info.description)
    case .unknownNetworkError(let request):
      description = String(format: format, "Unknown Error", request.description)
    case .apiNoResponse(let request):
      description = String(format: format, "API No Response", request.description)
    case .invalidURL:
      description = String(format: format, "Invalid or Bad URL")
    }
    return description
  }
}
