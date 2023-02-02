//
//  KILogger.swift
//  Genie
//
//  Created by 조승보 on 2022/04/14.
//

import Foundation

public enum LogLevel: String {
    case network = "💜 [NET]"
    case verbose = "💜 [VERBOSE]"
    case debug = "💚 [DEBUG]"
    case info = "💙 [INFO]"
    case warning = "💛 [WARNING]"
    case error = "❤️ [ERROR]"
}

public class KILogger {
    
    public static func network(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .network, message: message, file: file, function: function, line: line)
    }

    public static func verbose(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .verbose, message: message, file: file, function: function, line: line)
    }

    public static func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .debug, message: message, file: file, function: function, line: line)
    }

    public static func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .info, message: message, file: file, function: function, line: line)
    }

    public static func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .warning, message: message, file: file, function: function, line: line)
    }
    
    public static func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .error, message: message, file: file, function: function, line: line)
    }
    
    public static func outputLog(logLevel: LogLevel, message: Any, file: String, function: String, line: Int) {
        #if DEBUG
        printToConsole(logLevel: logLevel, message: message, file: file, function: function, line: line)
        #endif
    }
    
    static func printToConsole(logLevel: LogLevel, message: Any, file: String, function: String, line: Int) {
        
        let fileComponents = file.components(separatedBy: "/")
        var file = fileComponents.last ?? ""
        if let range = file.range(of: ".swift") {
            file.replaceSubrange(range, with: "")
        }

        let codePosition = file + "(L#" + String(line) + ") " + function

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let logHeader = formatter.string(from: date) + " "+logLevel.rawValue+" "+codePosition+" : "
        
        print(logHeader, terminator: "")
        print(message)
    }
}
