//
//  CEVItemCell.m
//  HomeOwner
//
//  Created by Vikram Aggarwal on 8/4/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVItemCell.h"

@implementation CEVItemCell

- (IBAction) showImage:(id)sender {
    if ([self actionBlock]) {
        // Execute it
        [self actionBlock]();
    }
}
@end
