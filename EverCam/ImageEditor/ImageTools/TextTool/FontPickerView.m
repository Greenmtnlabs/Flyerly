

#import "FontPickerView.h"

#import "UIView+Frame.h"
#import "PickerView.h"
#import "TextViewEdit.h"


const CGFloat kFontPickerViewConstantFontSize = 14;
const CGFloat kFontConstantFontSize = 14;

@interface FontPickerView()
<
PickerViewDelegate,
PickerViewDataSource
>
@end

@implementation FontPickerView
{
    PickerView *_pickerView;
    
    UITableView *fontTableView;
    NSArray *fontList2;
    TextViewEdit *textView;

}

+ (NSArray*)defaultSizes
{
    return @[@8, @10, @12, @14, @16, @18, @20, @24, @28, @32, @38, @44, @50];
}


+ (UIFont*)defaultFont
{
    // Default Initial Font
    return [UIFont fontWithName:@"Always Together"size:kFontPickerViewConstantFontSize];
}

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = true;

        /*
        fontTableView = [[UITableView alloc]initWithFrame: self.bounds style:UITableViewStylePlain];
        
        fontTableView.rowHeight = 44;
        
        fontTableView.scrollEnabled = true;
        fontTableView.showsVerticalScrollIndicator = true;
        fontTableView.userInteractionEnabled = true;
        fontTableView.bounces = true;
        
        fontTableView.delegate = self;
        fontTableView.dataSource = self;

        
        
        [self addSubview:fontTableView];
        */
    }
    
    return self;
}


/*
#pragma mark - FONT TABLEVIEW DELEGATES ============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return [fontList2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *fontStr = [fontList2 objectAtIndex:indexPath.row];
    cell.textLabel.text = [fontList2 objectAtIndex:indexPath.row];

    cell.textLabel.font = [UIFont fontWithName:fontStr size:kFontConstantFontSize];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontStr = [fontList2 objectAtIndex: indexPath.row];
    
    textView.font = [UIFont fontWithName:fontStr size:17];
    //[tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"font: %@", fontStr);
    
}
*/



- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _pickerView.foregroundColor = foregroundColor;
}

- (UIColor*)foregroundColor
{
    return _pickerView.foregroundColor;
}


- (void)setFontList:(NSArray *)fontList
{
    if(fontList != _fontList){
        _fontList = fontList;
        [_pickerView reloadComponent:0];
    }
}

- (void)setFontSizes:(NSArray *)fontSizes
{
    if(fontSizes != _fontSizes){
        _fontSizes = fontSizes;
        [_pickerView reloadComponent:1];
    }
}

- (void)setFont:(UIFont *)font
{
    UIFont *tmp = [font fontWithSize:kFontPickerViewConstantFontSize];
    
    NSInteger fontIndex = [_fontList indexOfObject: tmp];
    if(fontIndex==NSNotFound)
    {
        fontIndex = 0;
    }
    
    NSInteger sizeIndex = 0;
    for(sizeIndex=0; sizeIndex < _fontSizes.count; sizeIndex++){
        if(font.pointSize <= [_fontSizes[sizeIndex] floatValue]){
            break;
        }
    }
    
    [_pickerView selectRow:fontIndex inComponent:0 animated:NO];
    [_pickerView selectRow:sizeIndex inComponent:1 animated:NO];
}

- (UIFont*)font {
    
    UIFont *font = _fontList[[_pickerView selectedRowInComponent:0]];
    CGFloat size = [_fontSizes[[_pickerView selectedRowInComponent:1]] floatValue];
    return [font fontWithSize:size];
}

- (void)setSizeComponentHidden:(BOOL)sizeComponentHidden
{
    _sizeComponentHidden = sizeComponentHidden;
    
    [_pickerView setNeedsLayout];
}

#pragma mark- UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(PickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(PickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _fontList.count;
        case 1:
            return _fontSizes.count;
    }
    return 0;
}

#pragma mark- UIPickerViewDelegate

- (CGFloat)pickerView:(PickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.height/3;
}

- (CGFloat)pickerView:(PickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat ratio = self.sizeComponentHidden ? 1 : 0.8;
    switch (component) {
        case 0:
            return self.width*ratio;
        case 1:
            return self.width*(1-ratio);
    }
    return 0;
}

- (UIView*)pickerView:(PickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = nil;
    
    if([view isKindOfClass:[UILabel class]]){
        lbl = (UILabel *)view;
    
    } else {
        CGFloat W = [self pickerView:pickerView widthForComponent:component];
        CGFloat H = [self pickerView:pickerView rowHeightForComponent:component];
        CGFloat dx = 10;
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(dx, 0, W-2*dx, H)];
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.adjustsFontSizeToFitWidth = true;
        lbl.minimumScaleFactor = 0.5;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1];
    }
    
    switch (component) {
        case 0:
            lbl.font = _fontList[row];
            if(self.text.length > 0){
                lbl.text = self.text;
            } else {
                lbl.text = [NSString stringWithFormat:@"%@", lbl.font.fontName];
            }
            break;
        
        case 1:
            lbl.font = [UIFont systemFontOfSize:kFontPickerViewConstantFontSize];
            lbl.text = [NSString stringWithFormat:@"%@", self.fontSizes[row]];
            break;
        
            
        default: break;
    }
    
    return lbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(fontPickerView:didSelectFont:)]){
        [self.delegate fontPickerView:self didSelectFont:self.font];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRow:(NSIndexPath *)indexPath inComponent:(NSInteger)component {
    if([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.delegate fontPickerView:self didSelectFont:self.font];
    }
}

@end
