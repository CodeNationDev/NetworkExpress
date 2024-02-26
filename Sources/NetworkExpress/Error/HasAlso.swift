// NetworkExpress

import Foundation

protocol HasAlso { }

extension HasAlso {
  func also(_ closure: (Self) throws -> Void) rethrows -> Self {
    try closure(self)
    return self
  }
  
  @discardableResult func alsoLogSuccess(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.success($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogInfo(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.info($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogWarning(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.warning($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogError(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.error($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogViewcycle(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.viewcycle($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogData(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.data($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogService(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.service($0, file: file, line: line) }
  }
  
  @discardableResult func alsoLogTrace(file: StaticString = #filePath, line: UInt = #line) -> Self {
    also { Logger.trace($0, file: file, line: line) }
  }
}

extension NSObject: HasAlso {}
