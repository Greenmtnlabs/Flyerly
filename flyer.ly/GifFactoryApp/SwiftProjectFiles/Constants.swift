//
//  Constants.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Global constants.
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

// Fonts
let kLeagueSpartanFontName = "LeagueSpartan-Bold"

// Global parameters
/// The main app theme color.
let kGlobalTintColor = UIColor.sh_colorFromHexCode("000000")
/// The maximum allowed width (in pixels) of the GIF.
let kMaximumGifWidth = 2048
/// The maximum allowed height (in pixels) of the GIF.
let kMaximumGifHeight = 2048

// Settings Controller constants.
/// Determines setting's controller view width in compact size class.
let kSettingsControllerCompactContentWidth: CGFloat = 300.0
/// Determines setting's controller view width in regular size class.
let kSettingsControllerRegulartContentWidth: CGFloat = 400.0

// Labels
let kCancelActionButtonLabel = NSLocalizedString("Cancel", comment: "Cancel action button title")
let kOKActionButtonLabel = NSLocalizedString("OK", comment: "OK action button  title")

// Notifications
/// It is sent when the GIF was saved to the `Documents` folder.
let GFGifWasSavedToDocumentsNotification = "GFGifWasSavedToDocumentsNotification"
/// It is sent when the GIF was removed from the `Documents` folder.
let GFGifWasRemovedFromDocumentsNotification = "GFGifWasRemovedFromDocumentsNotification"
/// It is sent when the GIF file read operation is completed.
let GFDiskReadTaskFinishedNotification = "GFDiskReadTaskFinishedNotification"

// Keys
/// Gif notifications info keys.
/// This key is used to set and retrieve saved image URL from the info dictionary.
let kGFGifAssetInfoKey = "kGFGifAssetInfoKey"
/// This key is used to set and retrieve the object holding the properties of the current GIF request from the info dictionary.
let kGFGifRequestInfoKey = "kGFGifRequestInfoKey"
