//
//  CEVItemStore.h
//  HomeOwner
//
//  Created by Jimi on 7/18/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEVItem.h"

@interface CEVItemStore : NSObject
// The singleton instance
@property (nonatomic) CEVItemStore *singleton;
@property (nonatomic, readonly) NSArray *allItems;

// Returns the singleton instance.
+ (instancetype) sharedStore;

// Add an item and take ownership of it.
- (CEVItem *) createItem;

// Remove an item.
- (void) removeItem:(CEVItem *) item;

// Move item to new location
- (void) moveItemAtPosition:(NSUInteger)startPosition toPosition:(NSUInteger)endPosition;

/// Save the entire store to disk.
- (BOOL) saveToDisk;
@end
