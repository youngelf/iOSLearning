//
//  CEVDetailViewController.m
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/21/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVDetailViewController.h"
#import "CEVImageStore.h"

@interface CEVDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
- (IBAction)backgroundTapped:(id)sender;

@end

@implementation CEVDetailViewController

// Delete the image from this item.
- (IBAction)removeImage:(id)sender {
    [[CEVImageStore sharedStore] deleteImageForKey:[[self item] imageTag]];
    [[self imageView] setImage:nil];
}


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
    [picker setAllowsEditing:YES];
    
    // This shows a modal image picker view
    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Give up the keyboard when the background view is tapped
- (void)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

// Callback received after the user has picked and image
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"didFinishPickingMediaWithInfo called.");
    
    UIImage *image;
    // See if an edited image exists
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        // Use  the edited image;
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
    }

    [[self imageView] setImage:image];
    
    // Store this image with the appropriate tag.
    [[CEVImageStore sharedStore] setImage:image forKey:[[self item] imageTag]];
    
    // Now dismiss the view controller presented earlier
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    // Transfer all values over to the views.
    
    [[self nameField] setText:[[self item] itemName]];
    [[self valueField] setText:[NSString stringWithFormat:@"%d", [[self item] valueInDollars]]];
    [[self serialField] setText:[[self item] serialNumber]];
    [[self dateLabel] setText:[[[self item] dateCreated] description]];
    [[self imageView] setImage:[[CEVImageStore sharedStore] getImageForKey:[[self item] imageTag]]];
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
