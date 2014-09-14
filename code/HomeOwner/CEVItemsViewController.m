//
//  CEVItemsViewController.m
//  HomeOwner
//
//  Created by Jimi on 7/16/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVItemsViewController.h"
#import "CEVItem.h"
#import "CEVItemCell.h"
#import "CEVItemStore.h"
#import "CEVImageStore.h"
#import "CEVDetailViewController.h"
#import "CEVImageViewController.h"

@interface CEVItemsViewController()
@property (strong, nonatomic) NSMutableArray *cheap;
@property (strong, nonatomic) NSMutableArray *expensive;
@end


@implementation CEVItemsViewController

NSString *TAG = @"CEVItemCell";
NSString *APP_NAME = @"VikiOwner";

// Uncomment this to get multi-section support.
// #define MULTI_SECTION_DEFINED TRUE

// Set to true to get an extra line for end-of-list. Only works for single section.
bool MARK_END_OF_LIST = TRUE;


#ifdef MULTI_SECTION_DEFINED
bool MULTI_SECTION = TRUE;
#else
bool MULTI_SECTION = FALSE;
#endif


// We are changing the designated initializer so we need to call the
// designated initializer from here
- (instancetype) init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    // Create five items in the default store
    if (self) {
        CEVItemStore *store = [CEVItemStore sharedStore];
        if (MULTI_SECTION) {
            // Create two sections out of the shared store
            _cheap = [[NSMutableArray alloc] init];
            _expensive = [[NSMutableArray alloc] init];
            for (CEVItem *item in [store allItems]) {
                if ([item valueInDollars] >= 50) {
                    [_expensive addObject:item];
                } else {
                    [_cheap addObject:item];
                }
            }
        }
        NSLog(@"Store has: %@", [store allItems]);
        
        // Set the title
        [[self navigationItem] setTitle:APP_NAME];
        
        // Add a "+" button to add new items
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        [[self navigationItem] setLeftBarButtonItem:bbi];
        
        // And the right item is the "Edit" button
        [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    }
    return self;
}

// This used to be the designated initializer, but is no longer.
- (instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

// Multiple sections: Bronze challenge.
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (MULTI_SECTION) {
        return 2;
    }
    return 1;
}

#ifdef MULTI_SECTION_DEFINED
- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[ @"Cheap", @"Expensive"];
}
#endif

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    if (MULTI_SECTION) {
        if (section == 0) {
            return [[self cheap] count];
        } else {
            return [[self expensive] count];
        }
    }
    // Optionally add one if we need the end of the list.
    return [[[CEVItemStore sharedStore] allItems] count] + (MARK_END_OF_LIST ? 1 : 0);
}

- (CEVItem *) perhapsMultiItem: (NSIndexPath *) indexPath {
    NSUInteger rowIndex = [indexPath row];
    if (MULTI_SECTION) {
        if ([indexPath section] == 0) {
            return [[self cheap] objectAtIndex:rowIndex];
        } else {
            return [[self expensive] objectAtIndex:rowIndex];
        }
    }
    NSArray *allItems = [[CEVItemStore sharedStore] allItems];
    if (MARK_END_OF_LIST &&  rowIndex == [allItems count]) {
        // End of list, so zero value.
        return nil;
    }
    return [allItems objectAtIndex:rowIndex];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create a textview as the table view cell.
    CEVItemCell *cell = [tableView dequeueReusableCellWithIdentifier:TAG
                                                             forIndexPath:indexPath];
    // Without view recycling.
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:TAG];
    // Set the text on the item.
    CEVItem *item = [self perhapsMultiItem:indexPath];
    [[cell nameLabel] setText:[item itemName]];
    [[cell serialNumberLabel] setText:[item serialNumber]];
    [[cell valueLabel] setText:
     [NSString stringWithFormat:@"%d", [item valueInDollars]]];
    [[cell imageView] setImage:[item thumbnail]];
    __weak CEVItemCell *weakCell = cell;
    [cell setActionBlock:^(void) {
        NSLog(@"Testing");
        // Only on iPad, show a popover of the image
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            NSString *itemKey = [item imageTag];
            UIImage *img = [[CEVImageStore sharedStore] getImageForKey:itemKey];
            if (!img) {
                return;
            }
            // Make a rectangle
            CEVItemCell *strongCell = weakCell;
            CGRect rect = [[self view] convertRect:[[strongCell thumbnailView] bounds]
                                          fromView:[strongCell thumbnailView]];
            // Create a new image view controller with the correct image
            CEVImageViewController *ivc = [[CEVImageViewController alloc] init];
            [ivc setImage:img];
            [self setImagePopover:
             [[UIPopoverController alloc] initWithContentViewController:ivc]];
            [[self imagePopover] setDelegate:self];
            [[self imagePopover] setPopoverContentSize:CGSizeMake(600, 600)];
            [[self imagePopover] presentPopoverFromRect:rect
                                                 inView:self.view
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
        }
    }];
    return cell;
}

/// Dismiss the image popover if the user clicks anywhere outside it
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self setImagePopover:nil];
}

// True if this is the last row, false otherwise.
- (BOOL) isLastRow:(NSIndexPath *)indexPath {
    return [self isLastRowForIndex:[indexPath row]];
}

// True if this is the last row, false otherwise.
- (BOOL) isLastRowForIndex:(NSUInteger)index {
    return (MARK_END_OF_LIST && (index == [[[CEVItemStore sharedStore] allItems] count]));
}


// Gold challenge, changing the height of the row
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    if ([self isLastRow:indexPath]) {
        height = 20;
    } else {
        height = 44;
    }
    return height;
}

- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Bail";
}


- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isLastRow:indexPath];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isLastRow:indexPath];
}

// Gold challenge, disallow moving below the last level
- (NSIndexPath *) tableView:(UITableView *)tableView
    targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
        toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    // If we are trying to move to the last position, disallow
    BOOL isLastRow =
        (MARK_END_OF_LIST
         && ([proposedDestinationIndexPath row] >=
             [[[CEVItemStore sharedStore] allItems] count]));
    if (isLastRow) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void) viewDidLoad {
    // Register the tableview for the right tag for view recycling
    [super viewDidLoad];
    
    // Use our new item cell, which shows the image of the object.
    UINib *nib = [UINib nibWithNibName:@"CEVItemCell" bundle:nil];
//    [[self tableView] registerClass:[CEVItemCell class]
// forCellReuseIdentifier:TAG];
    [[self tableView] registerNib:nib forCellReuseIdentifier:TAG];
}

// Create a new item in the list.
- (IBAction)addNewItem:(id)sender {
    CEVItem *item = [[CEVItemStore sharedStore] createItem];

    // Use a modal view instead of populating the views right here.
    BOOL useModal = YES;
    if (useModal) {
        CEVDetailViewController *detail = [[CEVDetailViewController alloc] initForNewItem:YES];
        [detail setItem:item];
        // Set data reload as the callback
        [detail setDismissBlock:^{
            [[self tableView] reloadData];
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
        [nav setModalPresentationStyle:UIModalPresentationFormSheet];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

        // Extras: experimenting with modal presentation controllers.  This will make the child controller
        // take all of the CEVItemsViewController view but NOT the parent's view (the navigation bar will be left alone).
        BOOL overrideDefaultModalBehavior = NO;
        if (overrideDefaultModalBehavior) {
            // Ask the child to expect this short-circuiting.
            [nav setModalPresentationStyle:UIModalPresentationCurrentContext];
            // The presenting view controller is usually the top-level parent, but a child can
            // intercept the request in this manner
            [self setDefinesPresentationContext:YES];
        }
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        NSUInteger position = [[[CEVItemStore sharedStore] allItems] indexOfObject:item];
        NSIndexPath *path = [NSIndexPath indexPathForRow:position inSection:0];
        [[self tableView] insertRowsAtIndexPaths:@[path]
                                withRowAnimation:UITableViewRowAnimationTop];
    }
}

// Removing items
- (void) tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // We only handle deletes.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CEVItemStore *store = [CEVItemStore sharedStore];
        CEVItem *item = [[store allItems] objectAtIndex:[indexPath row]];
        [store removeItem:item];
        // And we also need to remove it from the table view. That's terrible.
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[CEVItemStore sharedStore] moveItemAtPosition:[sourceIndexPath row]
                                        toPosition:[destinationIndexPath row]];
}


// TO change the editing mode of the list view
- (IBAction)toggleEditingMode:(id)sender {
    if ([self isEditing]) {
        // Turn off editing mode
        [self setEditing:FALSE animated:TRUE];
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    } else {
        // Turn on editing mode
        [self setEditing:TRUE animated:TRUE];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
    
}

// Handle clicking on a single item
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Disallow clicks on the last element
    BOOL isLastRow = (MARK_END_OF_LIST
     && ([indexPath row] >= [[[CEVItemStore sharedStore] allItems] count]));
    if (isLastRow) {
        return;
    }

    CEVItem *item = [[[CEVItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    CEVDetailViewController *controller = [[CEVDetailViewController alloc] initForNewItem:NO];
    [controller setItem:item];
    [[self navigationController] pushViewController:controller animated:YES];
    
    [[self navigationItem] setTitle:[item itemName]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Reload the table view data in case the backing store has changed.
    [[self tableView] reloadData];
    // And set the title back to HomeOwner
    [[self navigationItem] setTitle:APP_NAME];
}
@end
