//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock {
    //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation 
    completionBlock:^(NSURL* assetURL, NSError* error) {
                              
        // Error handling
        if (error!=nil) {
            completionBlock(error);
            return;
        }

    //add the asset to the custom photo album
    [self addAssetURL: assetURL toAlbum:albumName
      withCompletionBlock:completionBlock];
        }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock {
    __block BOOL albumWasFound = false;
    
    //search all photo albums in the library
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum 
            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

            // Compare the names of the albums
            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                //target album is found
                albumWasFound = true;
                                
            // Get a hold of the photo's asset instance
            [self assetForURL: assetURL resultBlock:^(ALAsset *asset) {
                                                  
           //add photo to the target album
            [group addAsset: asset];
                                          
            //run the completion block
            completionBlock(nil);
            } failureBlock: completionBlock];

            // Album was found, bail out of the method
                return;
            }
                            
        if (group == nil && albumWasFound == false) {
            //photo albums are over, target album does not exist, thus create it
                                
            __weak ALAssetsLibrary* weakSelf = self;

            // Create new assets album
            [self addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
                                                                  
            // Get the photo's instance
            [weakSelf assetForURL: assetURL resultBlock:^(ALAsset *asset) {

            // Add photo to the newly created album
            [group addAsset: asset];
                                                                            
            // Call the completion block
            completionBlock(nil);
            } failureBlock: completionBlock];
                                                          
            } failureBlock: completionBlock];
            return;
            }
            
            } failureBlock: completionBlock];
    
}

@end
