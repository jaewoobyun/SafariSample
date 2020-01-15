//
//  logger.swift
//  ios-iCONex
//
//  Copyright © 2018 theloop, Inc. All rights reserved.
//

import Foundation

public enum LogLevel: String {
    case info       = "INFO"
    case debug      = "DEBUG"
    case verbose    = "VERBOSE"
    case warning    = "WARNING"
    case error      = "ERROR"
}

extension LogLevel {
    var symbol: String {
        switch self {
        case .info:
            return "💙"
            
        case .verbose:
            return "💜"
            
        case .debug:
            return "🦋"
            
        case .warning:
            return "💛"
            
        case .error:
            return "👹"
        }
    }
}

struct Log {
    static func Info<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        logger(.info, object(), file, function, line)
    }
    
    static func Verbose<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        logger(.verbose, object(), file, function, line)
    }
    
    static func Debug<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        logger(.debug, object(), file, function, line)
    }
    
    static func Warning<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        logger(.warning, object(), file, function, line)
    }
    
    static func Error<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        logger(.error, object(), file, function, line)
    }
    
    static func logger<T>(_ category: LogLevel, _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
            let value = object()
            var stringRepresentation: String = ""
        
            if let value = value as? CustomStringConvertible {
                stringRepresentation = value.description
            }
        
            let fileURL = URL(fileURLWithPath: file).lastPathComponent
            let queue = Thread.isMainThread ? "😀UI" : "😈BG"
        
            let logString = "\(category.symbol)\(category.rawValue): \(Date()) - <\(queue)> \(fileURL) \(function) [Line:\(line)] \n" + stringRepresentation
            //write(logString)
            print(logString)
//            if !BaseModel.isPublish {
//                //설마 로그때문은... 아니겠지?
//                print(logString)
//            }
            
        #else
        //println("Release Mode")
        #endif
        
    }
    
    static func write(_ string: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath = paths.first!
        let log = documentDirectoryPath.appendingPathComponent("log.txt")
        
        do {
            let handle = try FileHandle(forWritingTo: log)
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } catch {
            print(error.localizedDescription)
            do {
                try string.data(using: .utf8)?.write(to: log)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

extension String {
    func log(_ category: LogLevel, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        #if DEBUG
    
            let fileURL = URL(fileURLWithPath: file).lastPathComponent
            let queue = Thread.isMainThread ? "UI" : "BG"
            let logString = "\(category.rawValue): \(Date()) - <\(queue)> \(fileURL) \(function) [Line:\(line)]\n" + self
            print(logString)
//            write(logString)
//            if !BaseModel.isPublish {
//                print(logString)
//            }
            
        #else
        //println("Release Mode")
        #endif
        
    }
    
    
}
