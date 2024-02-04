#import "FLTableViewCell.h"
#import <objc/runtime.h>

//@interface SBUIController
//-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(id)arg3 activationSettings:(id)arg4 actions:(id)arg5 ;
//+(id)sharedInstanceIfExists;
//@end

@implementation FLTableViewCell
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 25;
    frame.size.width -= 2 * 25;
    [super setFrame:frame];
}

-(void)layoutIfNeeded {
    [super layoutIfNeeded];
    self.badgeView.center = CGPointMake(self.frame.size.width - 35, self.frame.size.height / 2);
    self.badgeTextLabel.center = CGPointMake(self.badgeView.frame.size.width / 2, self.badgeView.frame.size.height / 2);
}

- (void)setupBadgeView:(NSString *)badgeText {
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    badgeView.layer.cornerRadius = badgeView.frame.size.width / 2;
    badgeView.backgroundColor = [UIColor redColor];
    [self addSubview:badgeView];

    UILabel *badgeTextLabel = [[UILabel alloc] init];
    badgeTextLabel.text = badgeText;
    badgeTextLabel.textAlignment = NSTextAlignmentCenter;
    badgeTextLabel.font = [UIFont boldSystemFontOfSize:12];
    [badgeTextLabel sizeToFit];
    badgeTextLabel.frame = CGRectOffset(badgeTextLabel.frame, 6, 2);
    badgeTextLabel.textColor = [UIColor whiteColor];

    [badgeView addSubview:badgeTextLabel];

    self.badgeView = badgeView;
    self.badgeTextLabel = badgeTextLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0,0,32,32);
}

//-(void) launchApp {
//    [[objc_getClass("SBUIController") sharedInstanceIfExists] activateApplication:self.entry.application fromIcon:nil location:nil activationSettings:nil actions:nil];
//}
@end
