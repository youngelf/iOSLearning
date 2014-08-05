//
//  CEVDetailViewController.m
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/21/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVDetailViewController.h"
#import "CEVImageStore.h"
#import "CEVItemStore.h"

@interface CEVDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
- (IBAction)backgroundTapped:(id)sender;
/** The camera button in the toolbar. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (strong, nonatomic) UIPopoverController *imagePickerPopOver;
@end

@implementation CEVDetailViewController

// Delete the image from this item.
- (IBAction)removeImage:(id)sender {
    [[CEVImageStore sharedStore] deleteImageForKey:[[self item] imageTag]];
    [[self imageView] setImage:nil];
}


- (IBAction)takePicture:(id)sender {
    NSLog(@"Taking a picture");

    // If a popover is visible, iOS throws a hissy fit if the camera button is pressed again.
    // So if it is visible, dismiss it
    if ([self imagePickerPopOver]) {
        [[self imagePickerPopOver] dismissPopoverAnimated:YES];
        [self setImagePickerPopOver:nil];
        return;
    }
    
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

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Can create a popover here
        [self setImagePickerPopOver:[[UIPopoverController alloc] initWithContentViewController:picker]];
        [[self imagePickerPopOver] setDelegate:self];
        [[self imagePickerPopOver] presentPopoverFromBarButtonItem:[self cameraButton]
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
    } else {
        // This shows a modal image picker view
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self setImagePickerPopOver:nil];
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
    if ([self imagePickerPopOver]) {
        // on tablet
        [[self imagePickerPopOver] dismissPopoverAnimated:YES];
        [self setImagePickerPopOver:nil];
    } else {
        // on phone
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    // Transfer all values over to the views.
    
    [[self nameField] setText:[[self item] itemName]];
    [[self valueField] setText:[NSString stringWithFormat:@"%d", [[self item] valueInDollars]]];
    [[self serialField] setText:[[self item] serialNumber]];
    [[self dateLabel] setText:[[[self item] dateCreated] description]];
    [[self imageView] setImage:[[CEVImageStore sharedStore] getImageForKey:[[self item] imageTag]]];

    // Do orientation-specific arrangement
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:orientation];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Give up the keyboard
    [self resignFirstResponder];
    [[self item] setItemName:[[self nameField] text]];
    [[self item] setValueInDollars:[[[self valueField] text] intValue]];
    [[self item] setSerialNumber:[[self nameField] text]];
}

// Creating the photo view in code.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:nil];
    // Aspect fit the image.
    [image setContentMode:UIViewContentModeScaleAspectFit];
    // Do not produce a translated constraint. What does that mean?
    [image setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[self view] addSubview:image];
    [self setImageView:image];
    
    // When faced with a smaller image, allow the image view to grow vertially
    [image setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    // Do not allow this view to shrink too much
    [image setContentCompressionResistancePriority:700
                                           forAxis:UILayoutConstraintAxisVertical];

    
    // Dictionary from strings to objects
    NSDictionary *nameToObject = @{ @"imageView" : [self imageView],
                                    @"dateLabel" : [self dateLabel],
                                    @"toolbar" : [self bottomToolbar]};
    
    // The horizontal and vertical constraints
    NSArray *horizontal = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                           options:0
                           metrics:nil
                           views:nameToObject];
    NSArray *vertical = [NSLayoutConstraint
                         constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                         options:0
                         metrics:nil
                         views:nameToObject];
    [[self view] addConstraints:horizontal];
    [[self view] addConstraints:vertical];
}

/** Disable the camera button in landscape for iPhone. */
- (void) prepareViewsForOrientation:(UIInterfaceOrientation) orientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return;
    }

    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [[self cameraButton] setEnabled:NO];;
        [[self imageView] setHidden:YES];
    } else {
        [[self cameraButton] setEnabled:YES];;
        [[self imageView] setHidden:NO];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

/// Modal view of the same object
- (instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];
    if (self && isNew) {
        // Create new buttons
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(saveModal:)];
        [[self navigationItem] setRightBarButtonItem:done];

        // And a cancel button
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancelModal:)];
        [[self navigationItem] setLeftBarButtonItem:cancel];
    }
    return self;
}

- (void) saveModal:(id *) sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:[self dismissBlock]];
}

- (void) cancelModal:(id *) sender {
    // First remove the item from the store, and then save
    [[CEVItemStore sharedStore] removeItem:[self item]];
    [self saveModal:nil];
}



// Make the designated initializer illegal to call
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // Can't call this!
    @throw [[NSException alloc] initWithName:@"Illegal initializer."
                                      reason:@"Use initForNewName: instead"
                                    userInfo:nil];
    return nil;
}

@end
