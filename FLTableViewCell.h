#import "FLIconEntry.h"
@class SBApplication;


@interface FLTableViewCell : UITableViewCell
@property (nonatomic, weak) FLIconEntry *entry;
@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) UILabel *badgeTextLabel;
@property (nonatomic, strong) UITapGestureRecognizer *appLaunchRecognizer;
- (void)setupBadgeView:(NSString *)badgeText;
@end
