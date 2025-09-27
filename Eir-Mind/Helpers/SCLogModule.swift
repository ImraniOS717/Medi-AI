//
//  SCLogModule.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 27/9/2025.
//


import Foundation
import AVFoundation
import UIKit


struct SClog {
    var message: String
    var severity: MessageSeverity
}

/// Enum representing different message severity levels.
enum MessageSeverity {
    case low
    case moderate
    case high
}

/**
 A utility class for printing messages with different severity levels, displaying alerts, and showing toast messages.
 */
final class printer {
    
    static var logs = [SClog]()
    /**
     Print a message with an optional severity level, source file information, and method name.
     
     - Parameter text: The message to be printed.
     - Parameter severity: The severity level of the message (default is `.low`).
     - Parameter file: The source file where the print function is called (auto-generated).
     - Parameter function: The name of the method where the print function is called (auto-generated).
     - Parameter line: The line number where the print function is called (auto-generated).
     */
    class func print(_ text: Any, severity: MessageSeverity = .low, file: String = #file, function: String = #function, line: Int = #line, module: String = "") {
        let className = file.components(separatedBy: "/").last ?? "Unknown"
        let methodName = function
        
        let emoji: String
        switch severity {
        case .low:
            emoji = "💬"
        case .moderate:
            emoji = "⚠️"
        case .high:
            emoji = "❌"
        }
        
        var textToPrint = "\n\(emoji)\(emoji)\(emoji) (---- \(module) ---- \(className) / \(methodName) ---- atLine \(line) --------\n"
        var orignalText = "\(function)"
        //        Swift.print("\n\(emoji)\(emoji)\(emoji) (---- \(module) ---- \(className) / \(methodName) ---- atLine \(line) --------\n")
        
        if let value = text as? CustomStringConvertible {
            //            Swift.print(value.description)
            textToPrint += "(\(className)): " + value.description
            orignalText += value.description
            
        }else if let value = text as? Data,
                 let valueString = String(data: value, encoding: .utf8){
            //            Swift.print(valueString)
            textToPrint += "(\(className)): " + valueString
            orignalText += valueString
        }else {
            textToPrint += "(\(className)): " + (text as? String ?? "unable to log")
            orignalText += text as? String ?? "unable to log"
            dump(text)
        }
        
        textToPrint += "\n--------------------------------------------------------) \(emoji)\(emoji)\(emoji)\n"
        
        //        Swift.print("\n--------------------------------------------------------) \(emoji)\(emoji)\(emoji)\n")
        
        Swift.print(textToPrint)
        printer.logs.append(SClog(message: orignalText, severity: severity))
        
    }
}
