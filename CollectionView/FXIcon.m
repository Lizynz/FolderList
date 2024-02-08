#import "FXIcon.h"

@interface UIImage (UIApplicationIconPrivate)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format;
@end

@interface SBApplication
- (NSString *)bundleIdentifier;
- (NSString *)displayName;
- (id)initWithApplicationInfo:(id)arg1 ;
@end

@implementation FXIcon
- (id)initWithApplication:(SBApplication *)application {
    if ((self = [super init])) {
        self.application = application;
//        self.image = [UIImage _applicationIconImageForBundleIdentifier:application.bundleIdentifier format:10];
    }
    return self;
}
@end
