//
//  ImageLoader.h
//  Flyr
//
//  Created by RIKSOF Developer on 8/20/14.
//
//

#import "NBUImageLoader.h"

@interface ImageLoader : NBUImageLoader

/// Retrieve the shared singleton.
+ (NBUImageLoader *)sharedLoader;

/// Retrieve an image related to an arbitrary object.
/// @param object The reference object the loader should use to load an image.
/// @param size The desired NBUImageSize.
/// @param resultBlock The callback result block to be called once the image
/// is loaded.
- (void)imageForObject:(id)object
                  size:(NBUImageSize)size
           resultBlock:(NBUImageLoaderResultBlock)resultBlock;

/// The NBUImageLoader result block.
typedef void (^ImageLoaderResultBlock)(UIImage * image,
                                          NSError * error);

@end
