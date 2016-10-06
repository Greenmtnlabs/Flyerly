//
//  GFCancelOperationsIndicator.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Photos

// Lightweight class objects of which are passed by reference to async closures to indicate whether pending operations must be stopped.
class GFCancelOperationsHelper {
  /// Indicates whether the operations should be stopped.
  var shouldStopOperations = false
  /// Current request identifier that can be used to cancel the operation.
  var imageRequestID: PHImageRequestID?
  /// Specifies the set of file URLs for which the disk-related operations must be stopped.
  var outdatedFiles = Set<String>()
}