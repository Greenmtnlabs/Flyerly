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
#import "AFNetworking.h"

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
        
        NSURL *URL = [NSURL URLWithString: imageUrlString];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer = [AFHTTPResponseSerializer responseSerializer];
        [manager GET: URL.absoluteString parameters: nil success:^(NSURLSessionDataTask *task, id responseObject) {
            resultBlock(responseObject,nil);
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
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
