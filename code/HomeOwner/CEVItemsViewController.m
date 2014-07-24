//
//  CEVItemsViewController.m
//  HomeOwner
//
//  Created by Jimi on 7/16/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVItemsViewController.h"
#import "CEVItem.h"
#import "CEVItemStore.h"
#import "CEVDetailViewController.h"

@interface CEVItemsViewController()
@property (strong, nonatomic) NSMutableArray *cheap;
@property (strong, nonatomic) NSMutableArray *expensive;
@end


@implementation CEVItemsViewController

NSString *TAG = @"UiTableViewCell";

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
        [[self navigationItem] setTitle:@"HomeOwner"];
        
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

- (NSString *) perhapsMultiItemText: (NSIndexPath *) indexPath {
    NSUInteger rowIndex = [indexPath row];
    if (MULTI_SECTION) {
        if ([indexPath section] == 0) {
            return [[[self cheap] objectAtIndex:rowIndex] description];
        } else {
            return [[[self expensive] objectAtIndex:rowIndex] description];
        }
    }
    NSArray *allItems = [[CEVItemStore sharedStore] allItems];
    if (MARK_END_OF_LIST &&  rowIndex == [allItems count]) {
        // End of list, so create a string here.
        return @"End-Of-List";
    }
    return [[allItems objectAtIndex:rowIndex] description];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create a textview as the table view cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TAG
                                                             forIndexPath:indexPath];
    // Without view recycling.
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:TAG];
    // Set the text on the item.
    [[cell textLabel] setText:[self perhapsMultiItemText:indexPath]];

    return cell;
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
    [[self tableView] registerClass:[UITableViewCell class]
             forCellReuseIdentifier:TAG];
}

// Create a new item in the list.
- (IBAction)addNewItem:(id)sender {
    CEVItem *item = [[CEVItemStore sharedStore] createItem];
    NSUInteger position = [[[CEVItemStore sharedStore] allItems] indexOfObject:item];
    NSIndexPath *path = [NSIndexPath indexPathForRow:position inSection:0];
    [[self tableView] insertRowsAtIndexPaths:@[path]
                            withRowAnimation:UITableViewRowAnimationTop];
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
    CEVItem *item = [[[CEVItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    CEVDetailViewController *controller = [[CEVDetailViewController alloc] init];
    [controller setItem:item];
    [[self navigationController] pushViewController:controller animated:YES];
    
    [[self navigationItem] setTitle:[item itemName]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Reload the table view data in case the backing store has changed.
    [[self tableView] reloadData];
    // And set the title back to HomeOwner
    [[self navigationItem] setTitle:@"HomeOwner"];
}
@end
