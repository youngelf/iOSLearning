//
//  CEVDrawViewController.m
//  TouchTracker
//
//  Created by Vikram Aggarwal on 7/26/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVDrawViewController.h"
#import "CEVDrawView.h"

@implementation CEVDrawViewController

- (void)loadView {
    // Create a new DrawView and load that in.
    CEVDrawView *view = [[CEVDrawView alloc] initWithFrame:CGRectZero];
    // Multi-touch, baby.
    [view setMultipleTouchEnabled:YES];
    [self setView:view];
}

@end
