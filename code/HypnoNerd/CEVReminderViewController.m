//
//  CEVReminderViewController.m
//  HypnoNerd
//
//  Created by Jimi on 7/13/14.
//  Copyright (c) 2014 Jimi. All rights reserved.
//

#import "CEVReminderViewController.h"

@interface CEVReminderViewController()
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@end

@implementation CEVReminderViewController

- (IBAction) addReminder:(id)sender {
    NSDate *date = [[self datePicker] date];
    NSLog(@"The date is set to %@ and now is %@", date, [NSDate date]);
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    [note setFireDate:date];
    [note setAlertBody:@"Hypnotize me."];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tabBarItem] setTitle:@"Reminder"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Time.png"]];
    }
    return self;
};

- (void) viewWillAppear:(BOOL)animated {
    [[self datePicker] setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:60]];
}

@end
