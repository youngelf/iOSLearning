//
//  CEVDetailViewController.m
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/21/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVDetailViewController.h"

@interface CEVDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@end

@implementation CEVDetailViewController


- (IBAction)takePicture:(id)sender {
    NSLog(@"Taking a picture");
    
    // Find if a camera is available
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // I'll handle whatever this results in
    [picker setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This shows a modal image picker view
    [self presentViewController:picker animated:YES completion:nil];
}

// Callback received after the user has picked and image
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"didFinishPickingMediaWithInfo called.");
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [[self imageView] setImage:image];
    
    // Now dismiss the view controller presented earlier
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    // Transfer all values over to the views.
    
    [[self nameField] setText:[[self item] itemName]];
    [[self valueField] setText:[NSString stringWithFormat:@"%d", [[self item] valueInDollars]]];
    [[self serialField] setText:[[self item] serialNumber]];
    [[self dateLabel] setText:[[[self item] dateCreated] description]];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Give up the keyboard
    [self resignFirstResponder];
    [[self item] setItemName:[[self nameField] text]];
    [[self item] setValueInDollars:[[[self valueField] text] intValue]];
    [[self item] setSerialNumber:[[self nameField] text]];
}
@end
