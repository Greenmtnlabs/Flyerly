

#import "TextTool.h"

#import "CircleView.h"
#import "ColorPickerView.h"
#import "FontPickerView.h"
#import "TextViewEdit.h"
#import "TextSettingView.h"
#import "Configs.h"


static NSString *const TextViewActiveViewDidChangeNotification = @"TextViewActiveViewDidChangeNotificationString";
static NSString *const TextViewActiveViewDidTapNotification = @"TextViewActiveViewDidTapNotificationString";


@interface _TextView : UIView
<
UITextViewDelegate,
UITextFieldDelegate,
TextSettingViewDelegate
>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;

+ (void)setActiveTextView:(_TextView *)view;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;

@end



@interface ToolbarMenuItem(Private)
- (UIImageView*)iconView;
@end

@implementation ToolbarMenuItem(Private)
- (UIImageView*)iconView {
    return _iconView;
}
@end



@interface TextTool()
<
ColorPickerViewDelegate,
FontPickerViewDelegate,
UITextViewDelegate,
UITextFieldDelegate,
TextSettingViewDelegate,
UITableViewDataSource, UITableViewDelegate
>
@property (nonatomic, strong) _TextView *selectedTextView;
@end

@implementation TextTool
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    UIView *_workingView;
    UIScrollView *_menuScroll;

    UIActivityIndicatorView *_indicatorView;

    TextSettingView *_settingView;
    
    
    // Toolbar Buttons ===========
    ToolbarMenuItem *_textBtn;
    ToolbarMenuItem *_colorBtn;
    ToolbarMenuItem *_fontBtn;
    
    
    ToolbarMenuItem *_alignLeftBtn;
    ToolbarMenuItem *_alignCenterBtn;
    ToolbarMenuItem *_alignRightBtn;
    
    
    NSArray *fontList;
    UITableView *fontTableView;
    UIButton *okButton;
    
    NSArray *colorsArray;
    UIScrollView *colorScrollView;
    UIView *colorPickerView;
    UIButton *colorButt;
    int colorTag;

    NSString *fontStr;
}


+ (NSArray*)subtools {
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedString(@"TextTool", @"");
}

+ (BOOL)isAvailable
{
    return true;
}




#pragma mark- TEXT TOOL INIT ==============
- (void)setup {
    
    _originalImage = self.editor.imageView.image;
    _thumnailImage = _originalImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidChange:) name:TextViewActiveViewDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidTap:) name:TextViewActiveViewDidTapNotification object:nil];
    
    
    // Toolbar ScrollView =======
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    
    // Working View for merging images + text
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = true;
    [self.editor.view addSubview:_workingView];
    
    
    // Settings View (for delegates about chaing Text and Font)
    _settingView = [[TextSettingView alloc] init];
    _settingView.delegate = self;
    [self.editor.view addSubview:_settingView];
    
    
    
    
    /*  FONT TABLEVIEW INIT =========*/
    fontList = @[
                 @"Always Together",
                 @"Bebas Neue",
                 @"BlackJackRegular",
                 @"UpperEastSide",
                 @"Snickles",
                 @"Sigmar",
                 @"Pacifico",
                 @"Italianno",
                 @"Grand Hotel",
                 @"Boston Traffic",
                 @"ALusine",
                 @"Alpha Echo",
                 @"DSGabriele",
                 @"FortySecondStreetHB",
                 @"Geotica 2012",
                 @"Lobster 1.4",
                 @"Metropolis 1920",
                 @"5th Grade Cursive",
                 @"AdineKirnberg-Script",
                 @"Alpha54",
                 @"Arenq",
                 @"Bangers",
                 @"Blackout",
                 @"Boutiques of Merauke",
                 @"Candy Stripe (BRK)",
                 @"Dancing Script",
                 @"SeasideResortNF",
                 
                  ];
    
    CGRect tableRect = CGRectMake(0, self.editor.view.frame.size.height, self.editor.view.frame.size.width, 180);
    fontTableView = [[UITableView alloc]initWithFrame: tableRect style:UITableViewStylePlain];
    
    fontTableView.backgroundColor = [UIColor blackColor];
    fontTableView.rowHeight = 50;
    fontTableView.scrollEnabled = true;
    fontTableView.showsVerticalScrollIndicator = true;
    fontTableView.userInteractionEnabled = true;
    fontTableView.bounces = true;

    fontTableView.delegate = self;
    fontTableView.dataSource = self;
   // NSLog(@"FONTS LIST:  %@", fontList);
    
    [self.editor.view addSubview:fontTableView];

    /* END FONT TABLEVIEW =============================*/
    
    
    
    
    /* COLOR PICKER VIEW ==============================*/
    colorPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.editor.view.frame.size.height, self.editor.view.frame.size.width, 50)];
    colorPickerView.clipsToBounds = true;
    colorPickerView.backgroundColor = [UIColor lightGrayColor];
    [self.editor.view addSubview:colorPickerView];
    
    // ScrollView for Color Buttons =============
    colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, colorPickerView.frame.size.width, colorPickerView.frame.size.height)];
    [colorScrollView setBackgroundColor: [UIColor clearColor]];
    colorScrollView.scrollEnabled = true;
    colorScrollView.userInteractionEnabled = true;
    colorScrollView.showsHorizontalScrollIndicator = true;
    colorScrollView.showsVerticalScrollIndicator = false;
    [colorPickerView addSubview:colorScrollView];

    [self setColorsAndButtons];
    
    /* END COLOR PICKER VIEW ================*/

    
    
    [self setMenu];
    
    self.selectedTextView = nil;
    
    [self addNewText];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration
    animations:^{
        _menuScroll.transform = CGAffineTransformIdentity;
    }];
}



-(void)setColorsAndButtons {
    
     // Color Buttons & Colors ===================
     colorsArray = [NSArray arrayWithObjects:
    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
    [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],

    [UIColor colorWithRed:237.0/255.0 green:85.0/255.0 blue:100.0/255.0 alpha:1.0],
    [UIColor colorWithRed:218.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0],
    [UIColor colorWithRed:251.0/255.0 green:110.0/255.0 blue:82.0/255.0 alpha:1.0],
    [UIColor colorWithRed:246.0/255.0 green:187.0/255.0 blue:67.0/255.0 alpha:1.0],
    [UIColor colorWithRed:160.0/255.0 green:212.0/255.0 blue:104.0/255.0 alpha:1.0],
    [UIColor colorWithRed:140.0/255.0 green:192.0/255.0 blue:81.0/255.0 alpha:1.0],
    [UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:175.0/255.0 alpha:1.0],
    [UIColor colorWithRed:79.0/255.0 green:192.0/255.0 blue:232.0/255.0 alpha:1.0],
    [UIColor colorWithRed:93.0/255.0 green:155.0/255.0 blue:236.0/255.0 alpha:1.0],
    [UIColor colorWithRed:150.0/255.0 green:123.0/255.0 blue:220.0/255.0 alpha:1.0],
    [UIColor colorWithRed:236.0/255.0 green:136.0/255.0 blue:192.0/255.0 alpha:1.0],
    [UIColor colorWithRed:230.0/255.0 green:233.0/255.0 blue:238.0/255.0 alpha:1.0],
    [UIColor colorWithRed:101.0/255.0 green:109.0/255.0 blue:120.0/255.0 alpha:1.0],

    // You can add new UIColors here....
                    
                    
    nil];
    
    
     int xCoord = 0;
     int yCoord = 0;
     int buttonWidth = 50;
     int buttonHeight= colorPickerView.frame.size.height;
     int gapBetweenButtons = 0;
     
     // Loop for creating buttons
     for (int i = 0; i < colorsArray.count; i++) {
     colorButt = [UIButton buttonWithType:UIButtonTypeCustom];
     colorButt.frame = CGRectMake(xCoord, yCoord, buttonWidth,buttonHeight);
     colorButt.tag = i;
     [colorButt setBackgroundColor: [colorsArray objectAtIndex:i]];
     [colorButt addTarget:self action:@selector(colorButtTapped:) forControlEvents:UIControlEventTouchUpInside];
     [colorScrollView addSubview:colorButt];
     
     xCoord += buttonWidth + gapBetweenButtons;
     }
    
    colorScrollView.contentSize = CGSizeMake(buttonWidth * colorsArray.count +1, yCoord);
     
}
#pragma mark - COLOR BUTTONS METHOD ====================
-(void)colorButtTapped: (UIButton *)sender {
    _txtView.textColor = [colorsArray objectAtIndex: sender.tag];
    
    _settingView.selectedFillColor = [colorsArray objectAtIndex: sender.tag];
   
    _colorBtn.iconView.backgroundColor = [UIColor clearColor];

}


#pragma mark - FONT TABLEVIEW DELEGATES ============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return [fontList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *fontStr1 = [fontList objectAtIndex:indexPath.row];
    cell.textLabel.text = [fontList objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:fontStr1 size:17];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set Font of the _txtView =====
    fontStr = [fontList objectAtIndex: indexPath.row];

    _selectedTextView.font = [UIFont fontWithName:fontStr size:200];
  //  _settingView.selectedFont = _selectedTextView.font;
    [self textSettingView:_settingView didChangeFont:_selectedTextView.font];
    
}





#pragma mark - TOOBAL MENU BUTTONS - SETUP ======================
- (void)setMenu  {
    
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    NSArray *_menu = @[
                       @{@"title":NSLocalizedString(@"TextTool_MenuItemNew", @""),
                         @"icon":[UIImage imageNamed: @"ttAddTextButt"]
                        },
                       
                       @{@"title":NSLocalizedString(@"TextTool_MenuItemColor", @""),
                         @"icon":[UIImage imageNamed:@"ttColorButt"]
                         },
                       
                       @{@"title":NSLocalizedString(@"TextTool_MenuItemFont", @""),
                         @"icon":[UIImage imageNamed:@"ttFontButt"]
                         },
                       
                       @{@"title":NSLocalizedString(@"TextTool_MenuItemAlignLeft", @""),
                         @"icon":[UIImage imageNamed:@"ttAlLeft"]
                         },
                       @{@"title":NSLocalizedString(@"TextTool_MenuItemAlignCenter", @""),
                         @"icon":[UIImage imageNamed:@"ttAlCenter"]
                         },
                       @{@"title":NSLocalizedString(@"TextTool_MenuItemAlignRight", @""),
                         @"icon":[UIImage imageNamed:@"ttAlRight"]
                         },
                        
                       ];
    
    NSInteger tag = 0;
    
    for(NSDictionary *obj in _menu)   {
        ToolbarMenuItem *view = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuPanel:) toolInfo:nil];
        view.tag = tag++;
        view.title = obj[@"title"];
        view.iconImage = obj[@"icon"];
        
        
        switch (view.tag) {
            case 1:
                _colorBtn = view;
                break;
                
            case 2:
                _fontBtn = view;
                break;
                
            // Alignment buttons ========
            case 3:
                _alignLeftBtn = view;
                break;
            case 4:
                _alignCenterBtn = view;
                break;
            case 5:
                _alignRightBtn = view;
                break;
                
        }
        
        [_menuScroll addSubview:view];
        x += W;
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}


#pragma mark - TOOLBAR MENU BUTTONS - METHODS ================
- (void)tappedMenuPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    switch (view.tag) {
        case 0: {
            [self addNewText];
            [self hideColorPickerView];
        }
        case 1:
            // Color Button action =============
            [self hideFontTableView];
            [self showColorPickerView];
            break;
            
        case 2:
            // Fonts Button action ============
            [self showFontTableView];
            [self hideColorPickerView];
            break;

            // Text Alignment actions ==========
        case 3:
            [self setTextAlignment:NSTextAlignmentLeft];
            break;
        case 4:
            [self setTextAlignment:NSTextAlignmentCenter];
            break;
        case 5:
            [self setTextAlignment:NSTextAlignmentRight];
            break;
            }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kImageToolAnimationDuration
        animations:^{
        view.alpha = 1;
    }];
    
    
}




#pragma mark - SHOW / HIDE FONT TABLEVIEW ======================
-(void)showFontTableView {
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
        CGRect ftbFrame = fontTableView.frame;
        ftbFrame.origin.y = _menuScroll.top - 180;
        fontTableView.frame = ftbFrame;
    } completion:^(BOOL finished) {
        
        okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton setImage:[UIImage imageNamed:@"ttOkButt"] forState:UIControlStateNormal];
        okButton.frame = CGRectMake(self.editor.view.frame.size.width -40, fontTableView.frame.origin.y, 40, 40);
        [okButton addTarget:self action:@selector(hideFontTableView) forControlEvents:UIControlEventTouchUpInside];
        [self.editor.view addSubview:okButton];
    }];

}
-(void)hideFontTableView {
    [okButton removeFromSuperview];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
        CGRect ftbFrame = fontTableView.frame;
        ftbFrame.origin.y = self.editor.view.frame.size.height;
        fontTableView.frame = ftbFrame;
    } completion:^(BOOL finished) {
    }];
    
}



#pragma mark - SHOW / HIDE COLOR PICKER VIEW ======================
-(void)showColorPickerView {
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
        CGRect ftbFrame = colorPickerView.frame;
        ftbFrame.origin.y = _menuScroll.top - colorPickerView.frame.size.height;
        colorPickerView.frame = ftbFrame;
    } completion:^(BOOL finished) {
        
        okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton setImage:[UIImage imageNamed:@"ttOkButt"] forState:UIControlStateNormal];
        okButton.frame = CGRectMake(colorPickerView.frame.size.width -32, colorPickerView.frame.origin.y, 32, 32);
        [okButton addTarget:self action:@selector(hideColorPickerView) forControlEvents:UIControlEventTouchUpInside];
        [self.editor.view addSubview:okButton];
    }];
    
}
-(void)hideColorPickerView {
    [okButton removeFromSuperview];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
        CGRect ftbFrame = colorPickerView.frame;
        ftbFrame.origin.y = self.editor.view.frame.size.height;
        colorPickerView.frame = ftbFrame;
    } completion:^(BOOL finished) {
    }];
    
}



#pragma mark - CLEANUP ======================
- (void)cleanup  {
    
    [self.editor resetZoomScaleWithAnimated:true];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_settingView endEditing:true];
    
    // Remove all the UIViews
    [_settingView removeFromSuperview];
    [_workingView removeFromSuperview];
    [fontTableView removeFromSuperview];
    [colorPickerView removeFromSuperview];
    [okButton removeFromSuperview];
    
    [_indicatorView removeFromSuperview];

    [UIView animateWithDuration:kImageToolAnimationDuration
        animations:^{
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    }
    completion:^(BOOL finished) {
    [_menuScroll removeFromSuperview];
    }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_TextView setActiveTextView:nil];
    
    // An indicatorView appears and start animating
    dispatch_async(dispatch_get_main_queue(), ^{
        _indicatorView = [ImageEditorTheme indicatorView];
        _indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(
            [self buildImage:image], nil, nil);
        });
    });
}

#pragma mark- TEXTVIEW EDITOR OVER THE PHOTO - METHODS ============

- (UIImage*)buildImage:(UIImage*)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0);
    
    [image drawAtPoint:CGPointZero];
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return tmp;
}

- (void)setMenuBtnEnabled:(BOOL)enabled
{
    _textBtn.userInteractionEnabled =
    _colorBtn.userInteractionEnabled =
    _fontBtn.userInteractionEnabled =
    
    _alignLeftBtn.userInteractionEnabled =
    _alignCenterBtn.userInteractionEnabled =
    _alignRightBtn.userInteractionEnabled = enabled;
}


- (void)setSelectedTextView:(_TextView *)selectedTextView
{
    if(selectedTextView != _selectedTextView){
        _selectedTextView = selectedTextView;
    }
    
    [self setMenuBtnEnabled:(_selectedTextView!=nil)];
    
    if(_selectedTextView==nil){
        [self hideSettingView];
        
        _colorBtn.iconView.backgroundColor = [UIColor clearColor];
        //_settingView.selectedFillColor;
        _alignLeftBtn.selected = _alignCenterBtn.selected = _alignRightBtn.selected = NO;
        
    } else {
        /*
        _colorBtn.iconView.backgroundColor = selectedTextView.fillColor;
        _colorBtn.iconView.layer.borderColor = selectedTextView.borderColor.CGColor;
        _colorBtn.iconView.layer.borderWidth = MAX(2, 10*selectedTextView.borderWidth);
        */
        
        _settingView.selectedText = selectedTextView.text;
        _settingView.selectedFillColor = selectedTextView.fillColor;
        _settingView.selectedBorderColor = selectedTextView.borderColor;
        _settingView.selectedBorderWidth = selectedTextView.borderWidth;
        _settingView.selectedFont = selectedTextView.font;
        
        [self setTextAlignment:selectedTextView.textAlignment];
    }
}

- (void)activeTextViewDidChange:(NSNotification*)notification
{
    self.selectedTextView = notification.object;
  
}

- (void)activeTextViewDidTap:(NSNotification*)notification
{
    [self beginTextEditing];
}


#pragma mark - ADD A NEW TEXTVIEW (_TextView) ============
- (void)addNewText  {
    
    _TextView *view = [_TextView new];
    view.fillColor = [UIColor whiteColor];
    //_settingView.selectedFillColor;
    view.borderColor = _settingView.selectedBorderColor;
    view.borderWidth = _settingView.selectedBorderWidth;
    view.font = _settingView.selectedFont;
    
    
    CGFloat ratio = MIN( (0.6 * _workingView.width) / view.width, (0.2 * _workingView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_workingView.width/2, view.height/2 + 10);
    
    [_workingView addSubview:view];
    
    // Activate a new CLTextView ========
    [_TextView setActiveTextView:view];
    
    [self beginTextEditing];
}

- (void)beginTextEditing {
    
  //  [_settingView becomeFirstResponder];
    [self hideFontTableView];
    [self hideColorPickerView];
}


- (void)hideSettingView
{
    [_settingView endEditing: true];
    _settingView.hidden = true;
}


- (void)setTextAlignment:(NSTextAlignment)alignment
{
    self.selectedTextView.textAlignment = alignment;
    
    _alignLeftBtn.selected =
    _alignCenterBtn.selected =
    _alignRightBtn.selected =
    false;
    
    switch (alignment) {
        case NSTextAlignmentLeft:
            _alignLeftBtn.selected = true;
            break;
        case NSTextAlignmentCenter:
            _alignCenterBtn.selected = true;
            break;
        case NSTextAlignmentRight:
            _alignRightBtn.selected = true;
            break;
        default:
            break;
    }
}


-(void)hideKeyboard {
    [_settingView resignFirstResponder];
}



#pragma mark- Setting view delegate ===================

- (void)textSettingView:(TextSettingView *)settingView didChangeText:(NSString *)text
{
   
    self.selectedTextView.text = text;
    [self.selectedTextView sizeToFitWithMaxWidth:
     0.8 * _workingView.width lineHeight: 0.2 * _workingView.height];
    NSLog(@"didChangeText");
}


- (void)textSettingView:(TextSettingView*)settingView didChangeFillColor:(UIColor*)fillColor
{
   // _colorBtn.iconView.backgroundColor = fillColor;
    _colorBtn.iconView.backgroundColor = [UIColor clearColor];
    self.selectedTextView.fillColor = fillColor;
}

- (void)textSettingView:(TextSettingView*)settingView didChangeBorderColor:(UIColor*)borderColor
{
    _colorBtn.iconView.layer.borderColor = borderColor.CGColor;
    self.selectedTextView.borderColor = borderColor;
}

- (void)textSettingView:(TextSettingView*)settingView didChangeBorderWidth:(CGFloat)borderWidth
{
    _colorBtn.iconView.layer.borderWidth = MAX(2, 10*borderWidth);
    self.selectedTextView.borderWidth = borderWidth;
}


- (void)textSettingView:(TextSettingView *)settingView didChangeFont:(UIFont *)font
{
    self.selectedTextView.font = font;
    _txtView.font = font;
    [self.selectedTextView sizeToFitWithMaxWidth:
     0.8 *_workingView.width lineHeight:0.2*_workingView.height];
    NSLog(@"fontName:%@", font);
}


@end






#pragma mark- _TextView =============
@implementation _TextView  {
   
    TextViewEdit * _txtView;
    
    UIButton *_deleteButton;
    CircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    
    TextTool *txtTool;
}

+ (void)setActiveTextView:(_TextView *)view
{
    static _TextView *activeView = nil;
    if(view != activeView){
        [activeView setActive:NO];
        activeView = view;
        [activeView setActive:true];
        
        [activeView.superview bringSubviewToFront:activeView];
        
        NSNotification *n = [NSNotification notificationWithName:TextViewActiveViewDidChangeNotification object:view userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
}

- (id)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, 132, 132)];
    if(self){
   
        // Customize the Text Field ============
        _txtView = [[TextViewEdit alloc] init];
        _txtView.backgroundColor = [UIColor clearColor];
        _txtView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _txtView.layer.borderWidth = 2;
        _txtView.layer.cornerRadius = 20;
       // _txtView.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:200];
        _txtView.textColor = [UIColor whiteColor];
        _txtView.contentScaleFactor = 15/200.0;
        _txtView.textAlignment = NSTextAlignmentCenter;
        _txtView.tintColor = [UIColor whiteColor];
        _txtView.allowsEditingTextAttributes = true;
        _txtView.adjustsFontSizeToFitWidth = true;
        _txtView.returnKeyType = UIReturnKeyDone;
        
        // Text Field Placeholder =========
        UIColor *placeholderColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _txtView.attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:@"TAP TO EDIT" attributes:@{ NSForegroundColorAttributeName: placeholderColor }];
       
        _txtView.delegate = self;
      //  self.text = @"TAP TO EDIT";
        [self addSubview:_txtView];
        
        
         CGSize size = [_txtView sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
        _txtView.frame = CGRectMake(16, 16, size.width, size.height);
        self.frame = CGRectMake(0, 0, size.width + 32, size.height + 32);
        
        
        
       // Delete TextView Button =================
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"ttDeleteButt"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 36, 36);
        _deleteButton.center = _txtView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        
        // CircleView (Handler) ======================
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_txtView.width + _txtView.left, _txtView.height + _txtView.top);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor purpleColor];
        _circleView.borderWidth = 2;
        [self addSubview:_circleView];
        
        
        _arg = 0;
        [self setScale:1];
        
        [self initGestures];
    }
    return self;
}




#pragma mark - TEXT FIELD DELEGATES =========================

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_txtView resignFirstResponder];
    return true;
}

/*
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _txtView.allowsEditingTextAttributes = true;
    _txtView.adjustsFontSizeToFitWidth = true;
    _txtView.returnKeyType = UIReturnKeyDone;
    [_txtView becomeFirstResponder];
    return true;
}
*/

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _txtView.allowsEditingTextAttributes = true;
    _txtView.adjustsFontSizeToFitWidth = true;
    _txtView.returnKeyType = UIReturnKeyDone;
    self.text = @"";
    [[self class] setActiveTextView:self];

    return  true;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _txtView.allowsEditingTextAttributes = true;
    _txtView.adjustsFontSizeToFitWidth = true;
    _txtView.returnKeyType = UIReturnKeyDone;
    _txtView.keyboardAppearance = UIKeyboardAppearanceDark;
   // NSLog(@"BEGIN-Edit");
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
   // NSLog(@"END-Edit");
    [_txtView resignFirstResponder];
}



#pragma mark - INIT GESTURE RECOGNIZERS ===================
- (void)initGestures
{
    _txtView.userInteractionEnabled = true;
    
    [_txtView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_txtView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
   
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    
}


#pragma mark- TextView PROPERTIES ==================

- (void)setActive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _txtView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (BOOL)active
{
    return !_deleteButton.hidden;
}


- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight
{
    self.transform = CGAffineTransformIdentity;
    _txtView.transform = CGAffineTransformIdentity;
    
    CGSize size = [_txtView sizeThatFits:CGSizeMake(width / (15/200.0), FLT_MAX)];
    _txtView.frame = CGRectMake(16, 16, size.width, size.height);
    
    CGFloat viewW = (_txtView.width +32);
    CGFloat viewH = _txtView.font.lineHeight;
    
    CGFloat ratio = MIN(width / viewW,  lineHeight / viewH);

    [self setScale:ratio];
   // NSLog(@"ratio: %f", ratio);


}



- (void)setScale:(CGFloat)scale  {
    
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    _txtView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_txtView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_txtView.height + 32)) / 2;
    rct.size.width  = _txtView.width + 32;
    rct.size.height = _txtView.height + 32;
    self.frame = rct;
    
    _txtView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _txtView.layer.borderWidth = 1/_scale;
    _txtView.layer.cornerRadius = 3/_scale;
    
   // NSLog(@"scale: %f", scale);

}

- (void)setFillColor:(UIColor *)fillColor
{
    _txtView.textColor = fillColor;
}

- (UIColor*)fillColor
{
    return _txtView.textColor;
}


- (void)setBorderColor:(UIColor *)borderColor
{
    _txtView.outlineColor = borderColor;
}

- (UIColor*)borderColor
{
    return _txtView.outlineColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _txtView.outlineWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return _txtView.outlineWidth;
}



- (void)setFont:(UIFont *)font
{
    _txtView.font = [font fontWithSize:200];
}

- (UIFont *)font
{
    return _txtView.font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _txtView.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return _txtView.textAlignment;
}

- (void)setText:(NSString *)text
{
    if(![text isEqualToString:_text]){
        _text = text;
        _txtView.text = (_text.length > 0) ? _text : @"";
        _txtView.placeholder = @"";
        //NSLocalizedStringWithDefaultValue(@"CLTextTool_EmptyText", nil, [ImageEditorTheme bundle], @"Text", @"");
        }
    
}



#pragma mark- GESTURE EVENTS ================
- (void)pushedDeleteBtn:(id)sender
{
    _TextView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for (NSInteger i = index+1; i < self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_TextView class]]){
            nextTarget = (_TextView*)view;
            break;
        }
    }
    
    if(nextTarget == nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_TextView class]]){
                nextTarget = (_TextView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveTextView:nextTarget];
    [self removeFromSuperview];
}


- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    if(self.active){
        NSNotification *n = [NSNotification notificationWithName:TextViewActiveViewDidTapNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
    [[self class] setActiveTextView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveTextView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender {
    
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 15/200.0)];
}

@end


