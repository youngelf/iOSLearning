//
//  CEVDetailViewController.m
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/21/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVDetailViewController.h"

@interface CEVDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CEVDetailViewController

- (void) viewWillAppear:(BOOL)animated {
    // Transfer all values over to the views.
    
    [[self nameField] setText:[[self item] itemName]];
    [[self valueField] setText:[NSString stringWithFormat:@"%d", [[self item] valueInDollars]]];
    [[self serialField] setText:[[self item] serialNumber]];
    [[self dateLabel] setText:[[[self item] dateCreated] description]];
}

@end
