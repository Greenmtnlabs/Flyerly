/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "ToolbarMenuItem.h"

#import "ImageEditorTheme+Private.h"
#import "UIView+Frame.h"
#import "Configs.h"



@implementation ToolbarMenuItem


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = frame.size.width;
        
        
        /*==========================================
         Toolbar Icons Settings
        ===========================================*/
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, W-35, W-35)];
        _iconView.clipsToBounds = true;
        _iconView.layer.cornerRadius = 5;
        _iconView.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2) -5);
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconView];
        
        
        
        
        /*==========================================
         Toolbar Labels Settings
         ===========================================*/
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom, 60, 12)];
        _titleLabel.center = CGPointMake(self.frame.size.width/2, _iconView.bottom +7);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = MAIN_FONT;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
    }
    
    /*
   // CONSOLE LOGS
    NSLog(@"icon: %f - %f", _iconView.frame.size.width, _iconView.frame.size.height);
    NSLog(@"labelWidth: %f", _titleLabel.frame.size.width);
    */
    
    return self;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ImageToolInfo*)toolInfo
{
    self = [self initWithFrame:frame];
    if(self){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:gesture];
        
        self.toolInfo = toolInfo;
    }
    return self;
}

- (NSString*)title
{
    return _titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (UIImage*)iconImage
{
    return _iconView.image;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconView.image = iconImage;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.alpha = (userInteractionEnabled) ? 1 : 0.3;
}

- (void)setToolInfo:(ImageToolInfo *)toolInfo
{
    [super setToolInfo:toolInfo];
    
    self.title = self.toolInfo.title;
    if(self.toolInfo.iconImagePath){
        self.iconImage = self.toolInfo.iconImage;
    }
    else{
        self.iconImage = nil;
    }
}


- (void)setSelected:(BOOL)selected  {
    if(selected != _selected){
        _selected = selected;
        if(selected){
            self.backgroundColor = [UIColor clearColor];
        } else{
            self.backgroundColor = [UIColor clearColor];
        }
    }
}


@end

