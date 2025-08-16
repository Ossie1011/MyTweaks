#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Preferences/Preferences.h> // For reading settings

// Hook the battery display class
%hook UIStatusBarBatteryItemView

- (void)updateForNewBatteryLevel {
    %orig; // Keep the original battery update
    
    // Read custom battery percentage from Settings
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.ossies.batterycust"];
    NSInteger customBattery = [prefs integerForKey:@"BatteryPercentage"];

    if (customBattery == 0) customBattery = 100; // default if empty

    // Access the label that shows battery %
    UILabel *label = [self valueForKey:@"_stringView"];
    if (label) {
        label.text = [NSString stringWithFormat:@"%ld%%", (long)customBattery];
        [label setNeedsDisplay]; // Refresh UI
    }
}

%end
