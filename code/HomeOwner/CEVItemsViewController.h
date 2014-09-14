//
//  CEVItemsViewController.h
//  HomeOwner
//
//  Created by Jimi on 7/16/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEVItem.h"

@interface CEVItemsViewController : UITableViewController <UITableViewDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) CEVItem *item;
@property (strong, nonatomic) UIPopoverController *imagePopover;
@end
