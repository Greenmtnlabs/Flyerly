//
//  NSIndexPathHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) NSIndexPath extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Foundation

extension NSIndexPath {
  
  /**
   *  Creates an array of NSIndexPath objects from the given indices range.
   *
   *
   *  - parameter range: Range object with start and end indices.
   *  - parameter section: Section index the items represented by the indices located in. Default is 0.
   *
   *  - returns: Array filled with NSIndexPath objects created in accordance with the given indices.
   *
   */
  public class func sh_indexPathsFromRange(range: Range<Int>, section: Int = 0) -> [NSIndexPath]? {
    if (range.startIndex > range.endIndex) { return nil }
    
    var indexPaths = [NSIndexPath]()
    for item in range {
      indexPaths.append(NSIndexPath(forItem: item, inSection: section))
    }
    
    return indexPaths
  }
}