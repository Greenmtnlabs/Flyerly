/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "FilterBase.h"

@implementation FilterBase

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (NSArray*)subtools
{
    return nil;
}


+ (CGFloat)defaultDockedNumber
{
    return 0;
}


+ (NSString*)defaultTitle
{
    return @"FilterBase";
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

+ (UIImage*)applyFilter:(UIImage*)image
{
    return image;
}

@end




#pragma mark- FILTERS LIST ============================

@interface EmptyFilter : FilterBase

@end

@implementation EmptyFilter

+ (NSDictionary*)defaultFilterInfo
{
    NSDictionary *defaultFilterInfo = nil;
    if (defaultFilterInfo == nil){
        defaultFilterInfo =
        @{
            @"EmptyFilter": @{@"name":@"EmptyFilter",
            @"title":NSLocalizedString(@"EmptyFilter", @""),
            @"version":@(0.0), @"dockedNum":@(0.0) },
            
            @"LinearFilter": @{@"name":@"CISRGBToneCurveToLinear",
            @"title":NSLocalizedString(@"LinearFilter", @""),
            @"version":@(7.0), @"dockedNum":@(1.0)},
            
            @"VignetteFilter": @{@"name":@"CIVignetteEffect",
            @"title":NSLocalizedString(@"VignetteFilter", @""),
            @"version":@(7.0), @"dockedNum":@(2.0)},
            
            @"InstantFilter": @{@"name":@"CIPhotoEffectInstant",
            @"title":NSLocalizedString(@"InstantFilter", @""),
            @"version":@(7.0), @"dockedNum":@(3.0)},
            
            @"ProcessFilter": @{@"name":@"CIPhotoEffectProcess",
            @"title":NSLocalizedString(@"ProcessFilter", @""),
            @"version":@(7.0), @"dockedNum":@(4.0)},
            
            @"TransferFilter"  : @{@"name":@"CIPhotoEffectTransfer",
            @"title":NSLocalizedString(@"TransferFilter", @""),
            @"version":@(7.0), @"dockedNum":@(5.0)},
            
            @"SepiaFilter": @{@"name":@"CISepiaTone",
            @"title":NSLocalizedString(@"SepiaFilter", @""),
            @"version":@(5.0), @"dockedNum":@(6.0)},
            
            @"ChromeFilter": @{@"name":@"CIPhotoEffectChrome",
            @"title":NSLocalizedString(@"ChromeFilter", @""),
            @"version":@(7.0), @"dockedNum":@(7.0)},
            
            @"FadeFilter": @{@"name":@"CIPhotoEffectFade",
            @"title":NSLocalizedString(@"FadeFilter", @""),
            @"version":@(7.0), @"dockedNum":@(8.0)},
            
            @"CurveFilter": @{@"name":@"CILinearToSRGBToneCurve",
            @"title":NSLocalizedString(@"CurveFilter", @""),
            @"version":@(7.0), @"dockedNum":@(9.0)},
            
            @"TonalFilter": @{@"name":@"CIPhotoEffectTonal",
            @"title":NSLocalizedString(@"TonalFilter", @""),
            @"version":@(7.0), @"dockedNum":@(10.0)},
            
            @"NoirFilter": @{@"name":@"CIPhotoEffectNoir",
            @"title":NSLocalizedString(@"NoirFilter", @""),
            @"version":@(7.0), @"dockedNum":@(11.0)},
            
            @"MonoFilter": @{@"name":@"CIPhotoEffectMono",
            @"title":NSLocalizedString(@"MonoFilter", @""),
            @"version":@(7.0), @"dockedNum":@(12.0)},
            
            @"InvertFilter": @{@"name":@"CIColorInvert",
            @"title":NSLocalizedString(@"InvertFilter", @""),
            @"version":@(6.0), @"dockedNum":@(13.0)},
            
            @"DottedFilter": @{@"name":@"CIDotScreen",
            @"title":NSLocalizedString(@"DottedFilter", @""),
            @"version":@(6.0), @"dockedNum":@(14.0)},
            
            @"PurpleizedFilter": @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedString(@"PurpleizedFilter", @""),
            @"version":@(6.0), @"dockedNum":@(15.0)},
            
            @"LusterFilter": @{@"name":@"CIColorControls",
            @"title":NSLocalizedString(@"LusterFilter", @""),
            @"version":@(6.0), @"dockedNum":@(16.0)},

            @"SharpenFilter": @{@"name":@"CISharpenLuminance",
            @"title":NSLocalizedString(@"SharpenFilter", @""),
            @"version":@(6.0), @"dockedNum":@(17.0)},
            
    
        };
    }
    return defaultFilterInfo;
}


+ (id)defaultInfoForKey:(NSString*)key {
    return self.defaultFilterInfo[NSStringFromClass(self)][key];
}

+ (NSString*)filterName {
    return [self defaultInfoForKey:@"name"];
}

+ (NSString*)defaultTitle {
    return [self defaultInfoForKey:@"title"];
}

+ (BOOL)isAvailable {
    return true;
    //([UIDevice iosVersion] >= [[self defaultInfoForKey:@"version"] floatValue]);
}

+ (CGFloat)defaultDockedNumber {
    return [[self defaultInfoForKey:@"dockedNum"] floatValue];
}





#pragma mark - FILTERS IMPLEMENTATION ======================================

+ (UIImage*)applyFilter:(UIImage *)image
{
    return [self filteredImage:image withFilterName:self.filterName];
}

+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName {
    
    // No Filter ========================
    if([filterName isEqualToString:@"EmptyFilter"]){
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
   // NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    
    // CIVignette Filter ===============
    if([filterName isEqualToString:@"CIVignetteEffect"]){
        // parameters
        CGFloat R = MIN(image.size.width, image.size.height)/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    }
    
    // CIDotScreen Filter =======================
    if([filterName isEqualToString:@"CIDotScreen"]){
        // parameters
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        
        [filter setValue:[NSNumber numberWithFloat:5.00] forKey:@"inputWidth"];
        [filter setValue:[NSNumber numberWithFloat:5.00] forKey:@"inputAngle"];
        [filter setValue:[NSNumber numberWithFloat:0.70] forKey:@"inputSharpness"];
    }
    
    // Purpleized Filter ==============================
    if([filterName isEqualToString:@"CIColorMonochrome"]){
        // parameters
        [filter setValue:[CIColor colorWithRed:100.0/255.0 green:62.0/255.0 blue:191.0/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputIntensity"];
    }
    
    // Luster Filter ==============================
    if([filterName isEqualToString:@"CIColorControls"]){
        // Parameters
        [filter setValue:[NSNumber numberWithFloat:1.2] forKey:@"inputSaturation"];
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputBrightness"];
        [filter setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputContrast"];
    }
    
    // Sharpen Filter ==============================
    if([filterName isEqualToString:@"CISharpenLuminance"]){
        // Parameters
        [filter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputSharpness"];
    }
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end



@interface LinearFilter : EmptyFilter
@end
@implementation LinearFilter
@end

@interface VignetteFilter : EmptyFilter
@end
@implementation VignetteFilter
@end

@interface InstantFilter : EmptyFilter
@end
@implementation InstantFilter
@end

@interface ProcessFilter : EmptyFilter
@end
@implementation ProcessFilter
@end

@interface TransferFilter : EmptyFilter
@end
@implementation TransferFilter
@end

@interface SepiaFilter : EmptyFilter
@end
@implementation SepiaFilter
@end

@interface ChromeFilter : EmptyFilter
@end
@implementation ChromeFilter
@end

@interface FadeFilter : EmptyFilter
@end
@implementation FadeFilter
@end

@interface CurveFilter : EmptyFilter
@end
@implementation CurveFilter
@end

@interface TonalFilter : EmptyFilter
@end
@implementation TonalFilter
@end

@interface NoirFilter : EmptyFilter
@end
@implementation NoirFilter
@end

@interface MonoFilter : EmptyFilter
@end
@implementation MonoFilter
@end

@interface InvertFilter : EmptyFilter
@end
@implementation InvertFilter
@end

@interface DottedFilter : EmptyFilter
@end
@implementation DottedFilter
@end

@interface PurpleizedFilter : EmptyFilter
@end
@implementation PurpleizedFilter
@end

@interface LusterFilter : EmptyFilter
@end
@implementation LusterFilter
@end

@interface SharpenFilter : EmptyFilter
@end
@implementation SharpenFilter
@end
