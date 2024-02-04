#import "FLTableViewCell.h"
#import "FLIconEntry.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MobileCoreServices/MobileCoreServices.h>

static UITableView *sharedTableView;

@interface UIApplication (poop)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
@end

@interface _UIBackdropView : UIView
- (id)initWithStyle:(int)arg1;
@end

@interface SBActivationSettings : NSObject
- (void)setFlag:(long long)arg1 forActivationSetting:(unsigned)arg2 ;
@end

@interface LSApplicationProxy : NSObject
@property (nonatomic, readonly) NSNumber *staticDiskUsage;
+ (LSApplicationProxy *)applicationProxyForIdentifier:(id)arg1;
@end

@interface UISwipeGestureRecognizer (Private)
@property(assign, nonatomic) CGFloat minimumPrimaryMovement;
@property(assign, nonatomic) CGFloat maximumPrimaryMovement;
@end

@interface SBIconListView : UIView
- (void)hideAllIcons;
- (void)showAllIcons;
- (void)setAlphaForAllIcons:(CGFloat)arg1;
@end

@interface SBFolderTitleTextField : UIView
- (void)layoutSubviews;
@end

@interface SBFolderBackgroundView : UIView
+ (double)cornerRadiusToInsetContent;
+ (CGSize)folderBackgroundSize;
@end

@interface SBFloatyFolderBackgroundClipView : UIView
@property (nonatomic,readonly) SBFolderBackgroundView * backgroundView;
@end

@interface SBApplicationInfo
- (id)initWithApplicationProxy:(id)arg1;
@end

@interface SBApplication : NSObject
@property (nonatomic,copy) id badgeValue;
- (NSString *)bundleIdentifier;
- (NSString *)displayName;
- (id)initWithApplicationInfo:(id)arg1 ;
- (id)badgeNumberOrStringForIcon:(id)arg1 ;
@end

@interface SBApplicationIcon
- (id)initWithApplication:(SBApplication *)application;
- (SBApplication *)application;
@end

@interface UIWebClip : NSObject
@property (assign) BOOL fullScreen;
@property (nonatomic, retain) NSURL *pageURL;
@property (nonatomic, readonly, retain) UIImage *iconImage;
- (id)bundleIdentifier;
@end

@interface SBIcon : NSObject
@property (nonatomic, readonly, copy) NSString *displayName;
@property (nonatomic, readonly) long long badgeValue;
- (bool)isApplicationIcon;
- (bool)isBookmarkIcon;
- (bool)isWidgetIcon;
- (bool)isWidgetStackIcon;
- (id)applicationBundleID;
@end

@interface SBLeafIcon : SBIcon
@end

@interface SBBookmarkIcon : SBLeafIcon
@property (readonly, nonatomic) NSURL *launchURL;
@property (nonatomic, readonly) UIWebClip *webClip;
@end

@interface SBFolder : NSObject
- (NSArray *)icons;
- (id)allIcons;
@end

@interface SBFolderView : UIView
@property (nonatomic,readonly) UIScrollView * scrollView;
@end

@interface UIImage (UIApplicationIconPrivate)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format;
@end
@interface SBUIController
- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(id)arg3 activationSettings:(id)arg4 actions:(id)arg5 ;
+ (id)sharedInstanceIfExists;
@end

@interface SBIconListPageControl : UIView
@end

@interface SBFolderController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, readonly) SBFolderView *folderView;
@property (nonatomic, strong) UITableView *appListTableView;
@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, strong) SBFolder *folder;
@property (nonatomic, strong) NSArray *icons;
@property (retain, nonatomic) SBIconListPageControl *pageControl;
@property (nonatomic, strong) SBIconListView *customListView;
@property (nonatomic,copy,readonly) NSArray *iconListViews;
@property (nonatomic, strong) UIScrollView *appListScrollView;
@property (nonatomic, strong) NSMutableArray *iconEntries;
@property (nonatomic, assign) BOOL hasAddedCustomView;
@property (nonatomic, getter=isOpen) BOOL open;
- (void)setupAppList;
- (id)addEmptyListView;
- (void)deselectAllRows;
- (void)setupIconEntries;
- (void)uninstallApplication:(SBApplication *)application;
@end

@interface SBIconListModel : NSObject
@property (nonatomic,weak,readonly) SBFolder * folder;
- (id)initWithFolder:(id)arg1 maxIconCount:(unsigned long long)arg2;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstanceIfExists;
- (void)requestUninstallApplication:(id)arg0 options:(NSUInteger)arg1 withCompletion:(id)arg2;
- (void)requestUninstallApplicationWithBundleIdentifier:(id)arg0 options:(NSUInteger)arg1 withCompletion:(id)arg2;
- (void)uninstallApplication:(id)arg1 ;

@end

@interface SBFloatyFolderView : SBFolderView
- (CGFloat)folderSize;
@end

#define kRWSettingsPath @"/var/jb/var/mobile/Library/Preferences/com.shepgoba.folderlistprefs.plist"

_UIBackdropView *blurView;

int sortType = 0;
static CGFloat folderSize;

%hook SBFloatyFolderView
//- (NSUInteger)pageCount {//Hide Pages
//    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
//    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
//        return 0;
//    } else {
//        return %orig;
//    }
//}

- (CGRect)_frameForScalingView { //Folder Size
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        CGRect frame = %orig;
        return (CGRect){{frame.origin.x, frame.origin.y},{frame.size.width, [self folderSize]}};
    } else {
        return %orig;
    }
}

//- (BOOL)_tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 { //Disable Tap To Close Gesture
//    return false;
//}

%new
- (CGFloat)folderSize {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id FolderSize = [prefs objectForKey:@"FolderSize"];
    if ([FolderSize intValue] >= 350 && [FolderSize intValue] <= 550) {
        folderSize = [FolderSize floatValue];
        return folderSize;
    }
    return 350;
}

%end

//Hide animation - temporary solution
%hook SBFolderIconZoomAnimator
- (void)_performAnimationToFraction:(CGFloat)arg0 withCentralAnimationSettings:(id)arg1 delay:(CGFloat)arg2 alreadyAnimating:(BOOL)arg3 sharedCompletion:(id)arg4 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        arg2 = 0;
        arg3 = YES;
        %orig(arg0,arg1,arg2,arg3,arg4);
    }
    return %orig;
}

- (unsigned long long)_numberOfSignificantAnimations {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        return 0;
    }
    return %orig;
}
%end

%hook _SBInnerFolderIconZoomAnimator
- (unsigned long long)_numberOfSignificantAnimations {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        return 0;
    }
    return %orig;
}
%end
//End

%hook SBFolderBackgroundView
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        if ([[prefs objectForKey:@"Milk"] boolValue]) {
            return ;
        }
    }
    return %orig;
}

- (id)initWithFrame:(CGRect)frame {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        if ([[prefs objectForKey:@"Milk"] boolValue]) {
            SBFolderBackgroundView *view = %orig;
            
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[_UIBackdropView class]]) {
                    [subview removeFromSuperview];
                }
            }
            
            _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2060];
            blurView.backgroundColor = [UIColor systemBackgroundColor];
            blurView.alpha = 0.2;
            
            blurView.layer.masksToBounds = YES;
            blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
            
            CGRect newFrame = blurView.frame;
            newFrame.size = [%c(SBFolderBackgroundView) folderBackgroundSize];
            blurView.frame = newFrame;
            
            [view addSubview:blurView];
            
            BOOL isInDarkMode = ([[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark);
            if (isInDarkMode) {
                for (UIView *subview in view.subviews) {
                    if ([subview isKindOfClass:[_UIBackdropView class]]) {
                        [subview removeFromSuperview];
                    }
                }
                
                blurView.backgroundColor = [UIColor systemBackgroundColor];
                blurView.alpha = 0.2;
                
                blurView.layer.masksToBounds = YES;
                blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
                
                CGRect newFrame = blurView.frame;
                newFrame.size = [%c(SBFolderBackgroundView) folderBackgroundSize];
                blurView.frame = newFrame;
                
                [view addSubview:blurView];
            }
            return (SBFolderBackgroundView*)view;
        }
    }
    return %orig;
}

%end

%hook SBFolderTitleTextField
- (id)initWithFrame:(CGRect)arg1 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        if ([[prefs objectForKey:@"Milk"] boolValue]) {
            SBFolderTitleTextField *view = %orig;
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[_UIBackdropView class]]) {
                    [subview removeFromSuperview];
                }
            }
            
            _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2060];
            blurView.backgroundColor = [UIColor systemBackgroundColor];
            blurView.alpha = 0.2;
            
            blurView.layer.masksToBounds = YES;
            blurView.layer.cornerRadius = 30.0f;
            [view addSubview:blurView];
            
            BOOL isInDarkMode = ([[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark);
            if (isInDarkMode) {
                for (UIView *subview in view.subviews) {
                    if ([subview isKindOfClass:[_UIBackdropView class]]) {
                        [subview removeFromSuperview];
                    }
                }
                
                blurView.backgroundColor = [UIColor systemBackgroundColor];
                blurView.alpha = 0.2;
                
                blurView.layer.masksToBounds = YES;
                blurView.layer.cornerRadius = 30.0f;
                
                [view addSubview:blurView];
            }
            return (SBFolderTitleTextField*)view;
        }
    }
    return %orig;
}

%end

static BOOL ios15 = YES;

%hook SBFolderController
%property (nonatomic, strong) NSArray *icons;
%property (nonatomic, strong) UITableView *appListTableView;
%property (nonatomic, strong) SBIconListView *customListView;
%property (nonatomic, strong) NSString *cellReuseIdentifier;
%property (nonatomic, strong) NSMutableArray *iconEntries;
%property (nonatomic, assign) BOOL hasAddedCustomView;

- (void)viewDidLoad {
    %orig;
    if ((![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) || [self isKindOfClass:%c(SBRootFolderController)]) {
        return;
    }

    self.cellReuseIdentifier = @"FLCells";
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
        self.customListView = self.iconListViews.firstObject;
        
        if (ios15)
            [self.customListView hideAllIcons]; // Hide Icons
        self.pageControl.hidden = 1; //Hide Page Dots
        [self.customListView setAlphaForAllIcons:0.0]; // Clear Icons
        ((UIScrollView *)self.customListView.superview).scrollEnabled = NO;
        [self setupAppList];
        [self setupIconEntries];
        
//        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
//        if ([[prefs objectForKey:@"unistall"] boolValue]) {
//            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//            swipe.direction = UISwipeGestureRecognizerDirectionLeft; //seconds
//            swipe.delegate = self;
//            [self.appListTableView addGestureRecognizer:swipe];
//        }
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swipeUp];
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:swipeDown];
        
        [self.appListTableView registerClass:[FLTableViewCell class] forCellReuseIdentifier: self.cellReuseIdentifier];
        [self.customListView addSubview: self.appListTableView];
    }
}

- (void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 {
    %orig;
    if ([self isKindOfClass:NSClassFromString(@"SBFolderController")] || [self isKindOfClass:NSClassFromString(@"SBFloatyFolderController")]) {
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
        if ([[prefs objectForKey:@"replaceoriginalview"] boolValue]) {
            if ([self respondsToSelector:@selector(isOpen)]) {
                if (arg1) { // If edit mode is enabled
                    [self setValue:@NO forKey:@"open"]; // No Open Folder
                    [self.customListView setAlphaForAllIcons:1.0]; // Clear Icons
                    ((UIScrollView *)self.customListView.superview).scrollEnabled = YES;
                } else {
                    [self setValue:@YES forKey:@"open"]; // Open Folder
                }
            }
        }
    }
}

//Start
%new
- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.customListView showAllIcons];
        self.pageControl.hidden = 0;
        ((UIScrollView *)self.customListView.superview).scrollEnabled = YES;
    }
}

%new
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.customListView hideAllIcons];
        self.pageControl.hidden = 1;
        ((UIScrollView *)self.customListView.superview).scrollEnabled = NO;
    }
}
//END

- (void)setFolder:(SBFolder *)arg1 {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    if (ios15) {
        self.icons = [arg1.icons copy];
    } else {
        self.icons = [arg1.allIcons copy];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    [self.appListTableView reloadData];
}

%new
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.appListTableView deselectRowAtIndexPath:indexPath animated:YES];
    SBActivationSettings *customSettings = [[%c(SBActivationSettings) alloc] init];
    [customSettings setFlag:1 forActivationSetting:2];

    [self dismissViewControllerAnimated:YES completion:^{
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:[[self.icons[indexPath.section] application] bundleIdentifier] suspended:NO];
    }];
    
    SBBookmarkIcon *selectedIcon = self.icons[indexPath.section];
    if ([selectedIcon isBookmarkIcon]) {
        NSString *pageURLString = [NSString stringWithFormat:@"%@", [[selectedIcon webClip] pageURL]];
        if (pageURLString) {
            NSURL *pageURL = [NSURL URLWithString:pageURLString];
            
            UIApplication *application = [UIApplication sharedApplication];
            NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly: @NO};
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [application openURL:pageURL options:options completionHandler:^(BOOL success) {
                if (!success) {}}];
        }
    }
}

%new
- (void)setupIconEntries {
    self.iconEntries = [[NSMutableArray alloc] init];
    for (SBApplicationIcon *icon in self.icons) {
        FLIconEntry *newEntry = [[FLIconEntry alloc] initWithApplication:icon.application];
        [self.iconEntries addObject: newEntry];
    }
}

%new
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.icons.count;
}

%new
- (void)deselectAllRows {
    for (NSIndexPath *indexPath in self.appListTableView.indexPathsForSelectedRows) {
        [self.appListTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

%new
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

%new
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLTableViewCell *cell = [self.appListTableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
    FLIconEntry *entry = self.iconEntries[indexPath.section];

    cell.entry = entry;
    cell.textLabel.text = entry.application.displayName;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    SBBookmarkIcon *selectedIcon = self.icons[indexPath.section];
    if ([selectedIcon isBookmarkIcon]) {
        cell.textLabel.text = selectedIcon.displayName;
    }

    UIView *newView = [[UIView alloc] initWithFrame:cell.frame];
    newView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.75];
    newView.layer.cornerRadius = 16;
    cell.selectedBackgroundView = newView;

    cell.layer.cornerRadius = 16;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        SBApplication *application = entry.application;
        UIImage *cellImage;
        NSMutableArray *bookmarkIcons = [NSMutableArray array];
        
        if (application.bundleIdentifier && ![application.bundleIdentifier isEqualToString:@""]) {
            cellImage = [UIImage _applicationIconImageForBundleIdentifier:application.bundleIdentifier format:10 scale:[UIScreen mainScreen].scale];
        } else {
            cellImage = [UIImage _applicationIconImageForBundleIdentifier:application.bundleIdentifier format:10 scale:[UIScreen mainScreen].scale];
        }
            
        SBBookmarkIcon *selectedIcon = self.icons[indexPath.section];
        if ([selectedIcon isBookmarkIcon]) {
            UIImage *iconImage = [[selectedIcon webClip] iconImage];
            if (iconImage) {
                [bookmarkIcons addObject:iconImage];
            }
        }
        
        if (bookmarkIcons.count > 0) {
            NSUInteger index = indexPath.section % bookmarkIcons.count;
            cellImage = bookmarkIcons[index];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            FLTableViewCell *cell = (FLTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = cellImage;
            SBBookmarkIcon *selectedIcon = self.icons[indexPath.section];
            if ([selectedIcon isBookmarkIcon]) {
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 5;
                cell.imageView.clipsToBounds = YES;
            }
            [cell setNeedsLayout];
        });
    });
    
    if (@available(iOS 15, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            cell.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha: 0.4];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 0.65];
        }
    } else {
        cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 0.65];
    }
    
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"notificationBadgesEnabled"] boolValue]) {
        if (entry.application.badgeValue != nil) {
            if (!cell.badgeView) {
                cell.badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                cell.badgeView.layer.cornerRadius = cell.badgeView.frame.size.width / 2;
                cell.badgeView.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:cell.badgeView];
            }
            
//            if (!cell.badgeTextLabel) {
//                cell.badgeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
//                [cell.badgeView addSubview:cell.badgeTextLabel];
//            }
            
            cell.badgeTextLabel.text = [entry.application.badgeValue stringValue];
            [cell.badgeTextLabel sizeToFit];
            
            CGRect cellRect = cell.frame;
            CGRect badgeRect = [cell.badgeView frame];
            badgeRect.origin.x = CGRectGetMaxX(cellRect) - badgeRect.size.width - 4;
            badgeRect.origin.y = cellRect.origin.y + (cellRect.size.height - badgeRect.size.height) / 6 - badgeRect.size.height / 2;
            [cell.badgeView setFrame:badgeRect];
            cell.badgeView.hidden = NO;
        } else {
            cell.badgeView.hidden = YES;
        }
    }
    
    return cell;
}

//Hide Icons Orientation - needs to be fixed
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIInterfaceOrientation orientation = [[[UIApplication sharedApplication] windows].firstObject windowScene].interfaceOrientation;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && UIInterfaceOrientationIsLandscape(orientation)) {

        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.customListView hideAllIcons]; // Hide Icons
        [self.customListView setAlphaForAllIcons:0.0]; // Clear Icons
    }];
}

//%new
//-(void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer { // Uninstall Application | 0 - only delete / 1 - delete options
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.appListTableView];
//    NSIndexPath *row = [self.appListTableView indexPathForRowAtPoint:touchPoint];
//    if (row != nil) {
//        SBApplication *application = [self.icons[row.section] application];
//        if (application == nil)
//            return;
//        [[%c(SBApplicationController) sharedInstanceIfExists] requestUninstallApplicationWithBundleIdentifier:application.bundleIdentifier options:0 withCompletion:^{
//            [self.appListTableView reloadData];
//        }];
//    }
//}

%new
- (void)setupAppList {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        sortType = [prefs objectForKey:@"sortingType"] ? [[prefs objectForKey:@"sortingType"] intValue] : sortType;
    }
    
    if (sortType == 0) {
        //original
    }
    
    if (sortType == 1) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        self.icons = [self.folder.icons sortedArrayUsingDescriptors:@[sortDescriptor]]; //alphavite sort
    }
    
    if (sortType == 2) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)];
        self.icons = [self.folder.icons sortedArrayUsingDescriptors:@[sortDescriptor]]; //Reverse alphavite sort
    }
    
    self.appListTableView = [[UITableView alloc] initWithFrame:self.customListView.bounds];
    self.appListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.appListTableView.bounds.size.width, 5)];
    self.appListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.appListTableView.bounds.size.width, 15)];
    self.appListTableView.backgroundColor = [UIColor clearColor];
    self.appListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.appListTableView.delegate = self;
    self.appListTableView.dataSource = self;
    //self.appListTableView.layer.cornerRadius = 38;
    self.appListTableView.sectionHeaderHeight = 1;
    self.appListTableView.rowHeight = 52;

    SBFloatyFolderBackgroundClipView *folderBackgroundClipView = (SBFloatyFolderBackgroundClipView *) self.customListView.superview.superview;
    double cornerRadius = MSHookIvar<double>(folderBackgroundClipView.backgroundView, "_continuousCornerRadius");
    self.appListTableView.layer.cornerRadius = cornerRadius;
    self.appListTableView.scrollIndicatorInsets = UIEdgeInsetsMake(cornerRadius, 0, cornerRadius, 0);

}

%new
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

%end
