/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "ColorizeBase.h"

@implementation ColorizeBase

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
    return @"ColorizeBase";
}

+ (BOOL)isAvailable
{
    return false;
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




 
#pragma mark- COLORIZE FILTERS ============

@interface ColorizeEmptyFilter : ColorizeBase
@end

@implementation ColorizeEmptyFilter

+ (NSDictionary*)defaultFilterInfo  {

    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
        defaultFilterInfo =
        @{
            @"ColorizeEmptyFilter" : @{@"name": NSLocalizedString(@"ColorizeEmptyFilter", @""),
            @"title": @"Original",
            @"version":@(0.0), @"dockedNum":@(0.0)},
            
            @"ColorizeC1" : @{@"name":@"CIColorMonochrome",
            @"title":@"C1",
            @"version":@(7.0), @"dockedNum":@(1.0)},
            
            @"ColorizeC2" : @{@"name":@"CIColorMonochrome",
            @"title":@"C2",
            @"version":@(7.0), @"dockedNum":@(2.0)},
            
            @"ColorizeC3" : @{@"name":@"CIColorMonochrome",
            @"title":@"C3",
            @"version":@(7.0), @"dockedNum":@(3.0)},
            
            @"ColorizeC4" : @{@"name":@"CIColorMonochrome",
            @"title":@"C4",
            @"version":@(7.0), @"dockedNum":@(4.0)},
            
            @"ColorizeC5" : @{@"name":@"CIColorMonochrome",
            @"title":@"C5",
            @"version":@(7.0), @"dockedNum":@(5.0)},
            
            @"ColorizeC6" : @{@"name":@"CIColorMonochrome",
            @"title":@"C6",
            @"version":@(7.0), @"dockedNum":@(6.0)},
            
            @"ColorizeC7" : @{@"name":@"CIColorMonochrome",
            @"title":@"C7",
            @"version":@(7.0), @"dockedNum":@(7.0)},

            @"ColorizeC8": @{@"name":@"CIColorMonochrome",
            @"title":@"C8",
            @"version":@(7.0), @"dockedNum":@(8.0)},
            
        };
    }
    return defaultFilterInfo;
}

+ (id)defaultInfoForKey:(NSString*)key
{
    return self.defaultFilterInfo[NSStringFromClass(self)][key];
}

+ (NSString*)filterName
{
    return [self defaultInfoForKey:@"name"];
}


+ (NSString*)defaultTitle
{
    return [self defaultInfoForKey:@"title"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= [[self defaultInfoForKey:@"version"] floatValue]);
}

+ (CGFloat)defaultDockedNumber
{
    return [[self defaultInfoForKey:@"dockedNum"] floatValue];
}


+ (UIImage*)applyFilter:(UIImage *)image
{
    return [self filteredImage:image withFilterName:self.filterName andTitle:self.defaultTitle];
}





#pragma mark - FILTERS ATTRIBUTES SETUP ===========================

+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName andTitle: (NSString *)title
{
    if([filterName isEqualToString: NSLocalizedString(@"ColorizeEmptyFilter", @"")]){
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    
    /*========= FILTERS ATTRIBUTES TO EDIT AS YOU WANT =============*/
    
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat intensity;
    
    
    // C1 ==============================
    if([title isEqualToString:@"C1"]){
        // parameters
        r = 255;
        g = 200;
        b = 191;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }

    // C2 ==============================
    if([title isEqualToString:@"C2"]){
        // parameters
        r = 255;
        g = 239;
        b = 191;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];

    }

    // C3 ==============================
    if([title isEqualToString:@"C3"]){
        // parameters
        r = 245;
        g = 255;
        b = 191;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // C4 ==============================
    if([title isEqualToString:@"C4"]){
        // parameters
        r = 184;
        g = 255;
        b = 242;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // C5 ==============================
    if([title isEqualToString:@"C5"]){
        // parameters
        r = 202;
        g = 255;
        b = 191;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // C6 ==============================
    if([title isEqualToString:@"C6"]){
        // parameters
        r = 184;
        g = 229;
        b = 255;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // C7 ==============================
    if([title isEqualToString:@"C7"]){
        // parameters
        r = 193;
        g = 191;
        b = 255;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // C8 ==============================
    if([title isEqualToString:@"C8"]){
        // parameters
        r = 193;
        g = 164;
        b = 179;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    
    /*==============================================================*/
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end


#pragma mark - FILTER BUTTONS IMPLENTATIONS =============
@interface ColorizeC1 : ColorizeEmptyFilter
@end
@implementation ColorizeC1
@end

@interface ColorizeC2 : ColorizeEmptyFilter
@end
@implementation ColorizeC2
@end

@interface ColorizeC3 : ColorizeEmptyFilter
@end
@implementation ColorizeC3
@end

@interface ColorizeC4 : ColorizeEmptyFilter
@end
@implementation ColorizeC4
@end

@interface ColorizeC5 : ColorizeEmptyFilter
@end
@implementation ColorizeC5
@end

@interface ColorizeC6 : ColorizeEmptyFilter
@end
@implementation ColorizeC6
@end

@interface ColorizeC7 : ColorizeEmptyFilter
@end
@implementation ColorizeC7
@end

@interface ColorizeC8 : ColorizeEmptyFilter
@end
@implementation ColorizeC8
@end



