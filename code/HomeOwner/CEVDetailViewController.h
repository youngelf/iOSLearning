//
//  CEVDetailViewController.h
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/21/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEVItem.h"

@interface CEVDetailViewController : UIViewController
@property (nonatomic, weak) CEVItem *item;

- (instancetype) initForNewItem:(BOOL)isNew;

// The block to reload the data in the table view
@property (nonatomic, copy) void (^dismissBlock) (void);
@end
