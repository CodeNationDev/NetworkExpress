//
// Logger.swift

import Foundation
import os.log

public protocol ExternalLogger {
  func logWarning(_ message: Any, file: StaticString, line: UInt)
  func logError(_ message: Any, file: StaticString, line: UInt)
}

class Logger {

  static var isProduction: Bool = false
  private static var externalLogger: ExternalLogger? = nil

  static func setExternalLogger(_ externalLogger: ExternalLogger) {
    self.externalLogger = externalLogger
  }

  private static func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
    let prettyDate = dateFormatter.string(from: date)
    return prettyDate
  }

  private static func log(_ message: Any, type: LogType, file: StaticString, line: UInt) {
    if isProduction {
      guard type.flags.contains(.logOnProduction) else {
        return
      }
    }

    let ind = type.typeIndicator // indicator
    let date = formatDate(Date())

    let fullMessage = "\(ind) \(date)\nAt: \(file):\(line)\n\(message)"

    if type.flags.contains(.logToExternalSystem) {
      if type == .error {
        externalLogger?.logError(fullMessage, file: file, line: line)
      } else if type == .warning {
        externalLogger?.logWarning(fullMessage, file: file, line: line)
      }
    }

    if type.flags.contains(.logToSystem) {
      os_log("%@", log: .default, type: .default, fullMessage)
    } else if !isProduction { // is debug
      print(fullMessage)
    }
  }

  static func success(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .success, file: file, line: line)
  }

  static func info(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .info, file: file, line: line)
  }

  static func warning(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .warning, file: file, line: line)
  }

  static func error(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .error, file: file, line: line)
  }

  static func viewcycle(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .viewcycle, file: file, line: line)
  }

  static func data(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .data, file: file, line: line)
  }

  static func service(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .service, file: file, line: line)
  }

  static func trace(_ message: Any, file: StaticString = #filePath, line: UInt = #line) {
    log(message, type: .trace, file: file, line: line)
  }
}

extension LogType {

  var flags: [LoggerFlags] {
    switch self {
    case .success:
      return []
    case .info:
      return []
    case .data:
      return []
    case .service:
      return []
    case .viewcycle:
      return [.logOnProduction, .logToSystem]
    case .trace:
      return [.logOnProduction, .logToSystem]
    case .warning:
      return [.logOnProduction, .logToSystem, .logToExternalSystem]
    case .error:
      return [.logOnProduction, .logToSystem, .logToExternalSystem]
    }
  }

  var typeIndicator: String {
    switch self {
    case .success: return "✅✅"
    case .info: return "ℹ️ℹ️"
    case .warning: return "⚠️⚠️"
    case .error: return "🧨🧨"
    case .viewcycle: return "📱📱"
    case .data: return "🗄🗄"
    case .service: return "📬📬"
    case .trace: return "🔸🔸"
    }
  }
}

