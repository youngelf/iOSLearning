//
//  CEVAppDelegate.h
//  Hypnosister
//
//  Created by Jimi on 6/25/14.
//  Copyright (c) 2014 Jimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEVHypnosisView.h"

@interface CEVAppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CEVHypnosisView *hypnoView;

@end
