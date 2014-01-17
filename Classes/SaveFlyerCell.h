//
//  SaveFlyerCellViewController.h
//  Flyr
//
//  Created by Khurram on 17/01/2014.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SaveFlyerCell : UITableViewCell {



}


@property(nonatomic, strong)IBOutlet UILabel *createLabel;
@property(nonatomic, strong)IBOutlet UILabel * nameLabel;
@property(nonatomic, strong)IBOutlet UITextView * description;
@property(nonatomic, strong)IBOutlet UILabel * dateLabel;
@property(nonatomic, strong)IBOutlet UIImageView *cellImage;
@property(nonatomic, strong)IBOutlet UIImageView *backgroundImage;
@property(nonatomic, strong) NSString *filePath;
@property int flyerNumber;

@property(nonatomic, strong)IBOutlet UIImageView *fbImage;
@property(nonatomic, strong)IBOutlet UIImageView *twtImage;
@property(nonatomic, strong)IBOutlet UIImageView *emailImage;
@property(nonatomic, strong)IBOutlet UIImageView *instaImage;
@property(nonatomic, strong)IBOutlet UIImageView *flickImage;
@property(nonatomic, strong)IBOutlet UIImageView *tumbImage;


- (void)addToCell :(NSString *)tit :(NSString *)des :(NSString *)crted :(UIImage *)img :(NSString*)imgpath :  (int)flyerparam;

@end
