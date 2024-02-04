#import "FLPRootListController.h"
#import <spawn.h>

@implementation FLPRootListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respringDevice)];
    self.navigationItem.rightBarButtonItem = applyButton;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    
    return _specifiers;
}

- (void)respringDevice {
    UIAlertController *confirmRespringAlert = [UIAlertController alertControllerWithTitle:@"Apply settings?" message:@"This will respring your device." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pid_t pid;
        int status;
        const char* args[] = { "killall", "-9", "SpringBoard", NULL };
        posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
        waitpid(pid, &status, WEXITED);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [confirmRespringAlert addAction:cancel];
    [confirmRespringAlert addAction:confirm];
    
    [self presentViewController:confirmRespringAlert animated:YES completion:nil];
}

- (void)openTwitter {
    NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/shepgoba"];
    [[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];
}

- (void)openX {
    NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/lizynz1"];
    [[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];
}

@end

@interface SizeStepperCell : PSControlTableCell
@property (nonatomic, retain) UIStepper *control;
@end

@implementation SizeStepperCell
@dynamic control;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        self.accessoryView = self.control;
    }
    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    self.control.minimumValue = [specifier.properties[@"min"] doubleValue];
    self.control.maximumValue = [specifier.properties[@"max"] doubleValue];
    [self _updateLabel];
}

- (void)setCellEnabled:(BOOL)cellEnabled {
    [super setCellEnabled:cellEnabled];
    self.control.enabled = cellEnabled;
}

- (UIStepper *)newControl {
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    stepper.continuous = NO;
    
    stepper.minimumValue = 350;
    stepper.maximumValue = 550;
    
    stepper.stepValue = 50;
    stepper.value = 350;
    
    return stepper;
}

- (NSNumber *)controlValue {
    return @(self.control.value);
}

- (void)setValue:(NSNumber *)value {
    [super setValue:value];
    self.control.value = value.doubleValue;
}

- (void)controlChanged:(UIStepper *)stepper {
    [super controlChanged:stepper];
    [self _updateLabel];
}

- (void)_updateLabel {
    if (!self.control) {
        return;
    }
    NSString *labelText = [NSString stringWithFormat:@"%@ %d", self.specifier.name, (int)self.control.value];
    if (labelText != nil) {
        self.textLabel.text = labelText;
        [self setNeedsLayout];
    }
}

@end
