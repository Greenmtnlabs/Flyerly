//
//  NSFileManagerHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) NSFileManager extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Foundation

/// Cached date formatter (according to the Apple's documentation, creating a date formatter is not a cheap operation).
private let dateFormatter: NSDateFormatter = {
  let cachedDateFormatter = NSDateFormatter()
  
  // Create locale for fixed format date.
  // "en_US_POSIX" is a locale that's specifically designed to yield US English results regardless of both user and system preferences. "en_US_POSIX" is also invariant in time.
  let locale = NSLocale(localeIdentifier: "en_US_POSIX")
  cachedDateFormatter.locale = locale
  
  // Date format string where "SSS" - fractional seconds, "Z" - time zone offset (needed to handle daylight saving time).
  cachedDateFormatter.dateFormat = "yyyy'-'MM'-'dd'_'HH'.'mm'.'ss'.'SSS'_'Z"
  
  return cachedDateFormatter
}()

/**
 Enumberation that defines date types the file URLs can be sorted by.
 
 - AddedToDirectoryDate: The date the file was created or renamed.
 - AttributeModificationDate: The date the file attributes were most recently modified.
 - ContentAccessDate: The date the file was most recently accessed.
 - ContentModificationDate: The date the file was most recently modified.
 - CreationDate: The date the file was created.
 */
enum GFURLDateType {
  case AddedToDirectoryDate
  case AttributeModificationDate
  case ContentAccessDate
  case ContentModificationDate
  case CreationDate
}

extension NSFileManager {
  /**
   *  Constructs and returns a unique file name based on the current date.
   *
   *  - parameter prefix: String that represents a user-defined file name prefix. Pass _nil_ if you want a file name without a prefix.
   *
   *  - returns: String containing a file name in the following form: "PREFIX - Created at CURRENT_FORMATTED_DATE". For example, given the prefix "GIF" and the formatted date "2016-04-16_16.19.35.879_+0300" this string will be equal to the following: "GIF - Created at 2016-04-16_16.19.35.879_+0300".
   *
   */
  class func sh_generateFileNameUsingCurrentDate(withPrefix prefix: String?) -> String {
    // Resolve the required prefix.
    var filePrefix = prefix ?? ""
    
    if filePrefix.characters.count > 0 {
      // Append a separator to the prefix.
      filePrefix += " - "
    }
    
    // Append a helper phrase.
    filePrefix += NSLocalizedString("Created at ", comment: "Additional phrase that is inserted between the prefix string and the current date during the unique file name generation.")
    
    // Get the current date.
    let currentDate = NSDate()
    
    // Convert the date to the string.
    let formattedDate = dateFormatter.stringFromDate(currentDate)
    
    // Return the resulting string
    return filePrefix + formattedDate
  }
  
  /**
   *  Locates the standard system Documents directory and returns its URL.
   *
   *  - returns: NSURL representing Documents directory or nil in case of an error.
   *
   */
  class func sh_getDocumentsDirectoryURL() -> NSURL? {
    return try? NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
  }
  
  /**
   *  Performs a search in the specified directory and returns URLs for the found items.
   *
   *  - parameter directoryURL: The URL for the directory the search must be done in.
   *  - parameter pathExtension: Only the URLs of the files with the specified extension will be returned. Pass nil if you want to return all files of the directory.
   *  - parameter prefetchPropertiesForKeys: An array of keys that identify the file properties that you want to pre-fetch. Pre-fetching this information improves efficiency by touching the disk only once. An empty array disables pre-fetching. _nil_ means pre-fetch system-defined set of file properties.
   *  - parameter skipsHiddenFiles: If true the URLs for the hidden files won't be returned. Default is true.
   *
   *  - returns: An array of NSURL objects or nill in case of an error.
   *
   */
  class func sh_getFileURLsFromDirectory(directoryURL: NSURL, withPathExtension pathExtension: String?,  prefetchPropertiesForKeys keys: [String]?, skipsHiddenFiles: Bool = true) -> [NSURL]? {
    // Get default file manager.
    let fileManager = NSFileManager.defaultManager()
    
    // Create options for the directory enumeration.
    let options: NSDirectoryEnumerationOptions = skipsHiddenFiles ? .SkipsHiddenFiles : []
    
    // Get URLs for all of the files in the directory.
    let fileURLs = try? fileManager.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: keys, options: options)
    
    if let pathExtension = pathExtension {
      if let fileURLs = fileURLs {
        let filteredFileURLs = fileURLs.filter {
          $0.pathExtension == pathExtension
        }
        
        // Return only the file urls with the specified path extension.
        return filteredFileURLs
      }
    }
    
    return fileURLs
  }
  
  /**
   *  Sorts the array with file URLs by data which is determined in accordance with the dateResourceKey using in-place sort algorithm.
   *
   *  - parameter fileURLs: The array with file URLs that must be sorted.
   *  - parameter dateType: The enum value that determines the data type the array will be sorted by.
   *  - parameter ascending: A Boolean value that indicates whether the sorting will be in ascending order.
   *  - seealso: [Common File System Resource Keys](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURL_Class/#//apple_ref/doc/constant_group/Common_File_System_Resource_Keys)
   */
  class func sh_sortFileURLs(inout fileURLs: [NSURL], byDate dateType: GFURLDateType, ascending: Bool = true ) -> Void {
    var dateResourceKey = String()
    
    switch dateType {
    case .AddedToDirectoryDate:
      dateResourceKey = NSURLAddedToDirectoryDateKey
    case .AttributeModificationDate:
      dateResourceKey = NSURLAttributeModificationDateKey
    case .ContentAccessDate:
      dateResourceKey = NSURLContentAccessDateKey
    case .ContentModificationDate:
      dateResourceKey = NSURLContentModificationDateKey
    case .CreationDate:
      dateResourceKey = NSURLCreationDateKey
    }
    
    let comperisonResult = ascending ? NSComparisonResult.OrderedAscending : NSComparisonResult.OrderedDescending
    fileURLs.sortInPlace {
      var resourceValue1: AnyObject?
      if ((try? $0.getResourceValue(&resourceValue1, forKey: dateResourceKey)) == nil) {
        return false
      }
      
      var resourceValue2: AnyObject?
      if (try? $1.getResourceValue(&resourceValue2, forKey: dateResourceKey)) == nil {
        return false
      }
      
      if let firstDate = resourceValue1 as? NSDate, secondDate = resourceValue2 as? NSDate {
        return firstDate.compare(secondDate) == comperisonResult
      } else {
        return false
      }
    }
  }
}
