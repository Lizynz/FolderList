/*@interface UIImage (UIApplicationIconPrivate)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format;
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

@interface SBFolder : NSObject
- (NSArray *)icons;
- (id)allIcons;
@end

@interface SBIcon : NSObject
@end

@interface SBFolderIcon
@property (nonatomic,readonly) SBFolder * folder;
@end

@interface SBIconGridImage : UIImage
@end

@interface _SBFolderPageElement : NSObject
@property (nonatomic,weak) SBFolderIcon * folderIcon;
@end

@interface _SBIconGridWrapperView : UIImageView
@property (nonatomic, strong) UIImage *newImage;
@property (nonatomic,retain) _SBFolderPageElement * element;
@property (nonatomic, strong) NSArray *icons;
-(UIImage *) drawNewIconInRect:(CGRect)rect;
@end

%hook _SBIconGridWrapperView
%property (nonatomic, strong) UIImage *newImage;
%property (nonatomic, strong) NSArray *icons;

- (void)setElement:(id)arg1 {
    %orig;
    self.icons = self.element.folderIcon.folder.icons;
}

- (void)setImage:(UIImage*)arg1{
    %orig([self drawNewIconInRect:self.bounds]);
}

%new
- (UIImage *) drawNewIconInRect:(CGRect)rect {
    UIColor *cellColor;

    if (@available(iOS 13, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            cellColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha: 0.6];
        } else {
            cellColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha: 0.6];
        }
    } else {
        cellColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha: 0.6];
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGColorRef yellow = [[UIColor yellowColor] CGColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);

    CGContextSetFillColorWithColor(context, yellow);
    int i = 0;
    
    for (SBApplicationIcon *icon in self.icons) {
        UIImage *appImage = [UIImage _applicationIconImageForBundleIdentifier:((SBApplication *)icon.application).bundleIdentifier format:10];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, i, rect.size.width, rect.size.height / 5) cornerRadius:2.5];
        CGContextSetFillColorWithColor(context, cellColor.CGColor);
        [bezierPath fill];

        [appImage drawInRect:CGRectMake(3, i + 2.5, 5, 5)];
        i+=(rect.size.height / 5 + 2);
    }

    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return anImage;
}
%end*/
