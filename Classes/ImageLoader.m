//
//  ImageLoader.m
//  Flyr
//
//  Created by RIKSOF Developer on 8/20/14.
//
//

#import "ImageLoader.h"
#import "AFHTTPRequestOperation.h"
#import "NBUImageLoader.h"
#import "NBUImagePickerPrivate.h"


static NBUImageLoader * _sharedLoader;

@implementation ImageLoader

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      _sharedLoader = [NBUImageLoader new];
                  });
}

+ (NBUImageLoader *)sharedLoader
{
    return _sharedLoader;
}

- (void)imageForObject:(id)object
                  size:(NBUImageSize)size
           resultBlock:(ImageLoaderResultBlock)resultBlock
{
    // Already an image?
    if ([object isKindOfClass:[UIImage class]])
    {
        resultBlock(object,
                    nil);
        return;
    }
    
    if ( [object isKindOfClass:[NSString class]]){
        
        NSString *imageUrlString = (NSString *)object;
        NSURL *imageUrl = [[NSURL alloc] initWithString:imageUrlString];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            resultBlock(responseObject,nil);
            //return;
            //_imageView.image = responseObject;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        NSLog(@"");
        
    }
    
    // An asset?
    /*if ([object isKindOfClass:[NBUAsset class]])
    {
        switch (size)
        {
            case NBUImageSizeThumbnail:
            {
                resultBlock(((NBUAsset *)object).thumbnailImage,
                            nil);
                return;
            }
            case NBUImageSizeFullScreen:
            {
                resultBlock(((NBUAsset *)object).fullScreenImage,
                            nil);
                return;
                
            }
            case NBUImageSizeFullResolution:
            default:
            {
                resultBlock(((NBUAsset *)object).fullResolutionImage,
                            nil);
                return;
                
            }
        }
        return;
    }
    
    // Media info?
    if ([object isKindOfClass:[NBUMediaInfo class]])
    {
        switch (size)
        {
            case NBUImageSizeThumbnail:
            {
                resultBlock([(NBUMediaInfo *)object editedThumbnailWithSize:CGSizeMake(100.0, 100.0)],
                            nil);
                return;
            }
            case NBUImageSizeFullScreen:
            case NBUImageSizeFullResolution:
            default:
            {
                resultBlock(((NBUMediaInfo *)object).editedImage,
                            nil);
                return;
            }
        }
        return;
    }*/
    
    // A url?
    // ...
    
    // Give up
    NSError * error = [NSError errorWithDomain:NBUImageLoaderErrorDomain
                                          code:NBUImageLoaderObjectKindNotSupported
                                      userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:
                                                                              @"Image loader can't handle object: %@", object]}];
    //NBULogError(@"%@ %@", THIS_METHOD, error.localizedDescription);
    resultBlock(nil,
                error);
}

@end
