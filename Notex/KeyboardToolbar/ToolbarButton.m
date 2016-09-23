//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import "ToolbarButton.h"

#import "NotesList.h"

@interface ToolbarButton ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) eventHandlerBlock buttonPressBlock;

@end

@implementation ToolbarButton

+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title {
    _title = title;
    return [self init];
}

- (id)init
{
   // CGSize sizeOfText = [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.f]}];
    
    self = [super initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    if (self) {
        
        // Buttons Layout Setup ============
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self setTitle:self.title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont fontWithName:@"Comfortaa-Light" size:14.f];
        self.titleLabel.textColor = green;
    }
    return self;
}

- (void)addEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvent {
    self.buttonPressBlock = eventHandler;
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:controlEvent];
}

- (void)buttonPressed {
    self.buttonPressBlock();
}

@end
