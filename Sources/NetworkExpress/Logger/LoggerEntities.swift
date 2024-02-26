//
//  LoggerEntities.swift

public enum LogType {
  case success
  case info
  case warning
  case error
  case viewcycle
  case data
  case service
  case trace
}

enum LoggerFlags {
  case logOnProduction
  case logToSystem
  case logToExternalSystem
}
