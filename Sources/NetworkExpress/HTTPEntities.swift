//

import Foundation

public struct HttpOperationInfo {
  private var operationId: String

  // request
  var url: String
  var httpMethod: RequestMethod
  var requestHeaders: [String: String]
  var requestBody: String

  // response
  var statusCode: Int
  var responseHeaders: [AnyHashable : Any]
  var responseBody: String

  init(request: URLRequest, response: HTTPURLResponse, responseData: Data) {
    self.operationId = UUID()
      .uuidString
      .replacingOccurrences(of: "-", with: "")

    self.url = request.url?.absoluteString ?? ""
    self.httpMethod = RequestMethod(rawValue: request.httpMethod ?? "") ?? .get
    self.requestHeaders = request.allHTTPHeaderFields ?? [:]
    self.requestBody = request.httpBody?.toUtf8String() ?? ""

    self.statusCode = response.statusCode
    self.responseHeaders = response.allHeaderFields
    self.responseBody = responseData.toUtf8String()
  }

}

extension HttpOperationInfo: CustomStringConvertible {
  public var description: String {
    """
===============
HTTP Request (\(operationId))
\(httpMethod) \(url)

Headers:
\(requestHeaders)

Body:
\(requestBody)

---------------

HTTP Response (\(operationId))
Status code: \(statusCode)

Response headers:
\(responseHeaders)

Response body:
\(responseBody)
===============
""".trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

extension HttpOperationInfo: Equatable {
  public static func == (lhs: HttpOperationInfo, rhs: HttpOperationInfo) -> Bool {
    lhs.operationId == rhs.operationId
  }
}
