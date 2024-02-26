//
//  CustomSessionTask.swift

import Foundation

class CustomSessionTaskDelegate: NSObject, URLSessionTaskDelegate {
  private let followRedirections: Bool
  
  init(followRedirections: Bool) {
    self.followRedirections = followRedirections
  }
  
  
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest,
                  completionHandler: @escaping (URLRequest?) -> Void) {


    if followRedirections {
      completionHandler(request)
    } else {
      Logger.warning("\(NSString(string: "\(response.allHeaderFields)"))")
      completionHandler(nil)
    }
  }
}
