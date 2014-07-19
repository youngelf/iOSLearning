//
//  CEVHypnosisViewController.m
//  HypnoNerd
//
//  Created by Jimi on 7/7/14.
//  Copyright (c) 2014 Jimi. All rights reserved.
//

#import "CEVHypnosisViewController.h"
#import "CEVHypnosisView.h"

@interface CEVHypnosisViewController()
@property (nonatomic) CEVHypnosisView *hypnosis;
@property (nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation CEVHypnosisViewController

- (void) loadView {
    [self setHypnosis:[[CEVHypnosisView alloc] init]];
    
    // The challenge: a three state toggle for color.
    [self setSegmentedControl:[[UISegmentedControl alloc]
                                            initWithItems:@[@"Red", @"Green", @"Blue"]]];
    [[self segmentedControl] addTarget:self
                         action:@selector(redColorSelected:)
               forControlEvents:UIControlEventValueChanged];
    [[self segmentedControl] setFrame:CGRectMake(0, 400, 300, 30)];
    // Uncomment the next line to get a segmented control.
    // [[self hypnosis] addSubview:[self segmentedControl]];

    // A text field for what we should be hypnotised with.
    CGRect inputFieldRect = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:inputFieldRect];
    // Set the border style so you can see it clearly.
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setPlaceholder:@"Hypnotize me"];
    [textField setReturnKeyType:UIReturnKeyDone];
    // This control will handle all events from the textfield
    [textField setDelegate:self];
    
    [[self hypnosis] addSubview:textField];

    [self setView:[self hypnosis]];
}

- (IBAction) redColorSelected:(id)sender {
    NSLog(@"Sender is %@", sender);
    long selected = [[self segmentedControl] selectedSegmentIndex];
    UIColor *toSetColor;
    if (selected == 0) {
        toSetColor = [UIColor redColor];
    } else if (selected == 1) {
        toSetColor = [UIColor greenColor];
    } else {
        toSetColor = [UIColor blueColor];
    }
    [[self hypnosis] setCircleColor:toSetColor];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tabBarItem] setTitle:@"Hypnosis"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Hypno.png"]];
    }
    return self;
};

- (BOOL) textFieldShouldReturn:(UITextField *)field {
    NSLog(@"Got the string: %@", [field text]);
    [self drawHypnoticMessage:[field text]];
    [field resignFirstResponder];
    return YES;
}

- (void) drawHypnoticMessage: (NSString *)message {
    const int TOTAL_MESSAGES=20;
    
    if (TOTAL_MESSAGES <= 0) return;
    
    CGSize size = [[self view] bounds].size;

    // The first one for size measurement.
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:message];
    
    // Make the label as big as the message it holds.
    [label sizeToFit];

    int startWidth = size.width - [label bounds].size.width;
    int startHeight = size.height - [label bounds].size.height;
    // But don't add this to anything.
    
    for (int i = 0; i < TOTAL_MESSAGES; ++i) {
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:message];
        
        // Make the label as big as the message it holds.
        [label sizeToFit];

        CGRect frame = [label frame];
        frame.origin = CGPointMake(arc4random() % startHeight,
                                   arc4random() % startWidth);
        
        // Try without this
        [label setFrame:frame];
        
        [[self view] addSubview:label];
    }
}

@end
