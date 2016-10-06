//
//  XCGLoggerHelper.swift
//  Pods
//
//  DESCRIPTION:
//      Swift helper (SH) extension that simplifies configuration of the XCGLogger.
//
//  Created by Storix on 6/14/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import XCGLogger

/// Global XCGLogger instance that can be used in each source file.
let log: XCGLogger = XCGLogger.defaultInstance()

extension XCGLogger {
  
  /**
      Configures the properties of the default logger.
   
      - important: For proper logger configuration call this method after the application finishes launching.
   */
  static func sh_configureDefaultLogger() -> Void {
    //  Log messages format is determined depending on DEBUG flag presence.
    //  There are several predefined log levels you can easily set here:
    //      Verbose, Debug, Info, Warning, Error, Severe, None(disable logging).
    //  XCGLogger will only print messages with a log level that is >= its current log level setting (priority from left to right).
    #if DEBUG
      log.setup(.Debug, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLogLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLogLevel: nil)
    #else
      log.setup(.Warning, showLogIdentifier: false, showFunctionName: true, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLogLevel: nil)
    #endif
  }
}
