//
//  CEVItemStore.m
//  HomeOwner
//
//  Created by Jimi on 7/18/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVItemStore.h"
#import "CEVImageStore.h"
@interface CEVItemStore()
@property (nonatomic) NSMutableArray *privateItems;

@end

// Stores all the items that we display in a table. This is a singleton.
@implementation CEVItemStore

+ (instancetype) sharedStore {
    // Creating a single object in a thread-safe way
    // If the singleton instance exists, return that.
    static CEVItemStore *store = nil;
    if (!store) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            store = [[CEVItemStore alloc] initPrivate];
            
        });
    }
    return store;
}

// Not meant to be called: Call CEVItemStore.sharedStore instead.
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Call [CEVItemStore sharedStore] instead"
                                 userInfo:nil];
    return nil;
}

- (instancetype) initPrivate {
    self = [super init];
    // Try to restore from disk, if possible
    NSString *path = [self itemArchivePath];
    _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    // Set up the Mutable array
    if (!_privateItems) {
        [self setPrivateItems:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (NSArray *) allItems {
    return [self privateItems];
}

- (CEVItem *) createItem {
    CEVItem *item = [[CEVItem alloc] init];
    [[self privateItems] addObject:item];
    return item;
}

- (void) removeItem:(CEVItem *) item {
    // Delete the image associated with this item
    [[CEVImageStore sharedStore] deleteImageForKey:[item imageTag]];
    [[self privateItems] removeObjectIdenticalTo:item];
}

- (void) moveItemAtPosition:(NSUInteger)startPosition toPosition:(NSUInteger)endPosition  {
    if (startPosition == endPosition) {
        return;
    }
    // Find the item
    NSMutableArray *allItems = [[CEVItemStore sharedStore] privateItems];
    CEVItem *item = [allItems objectAtIndex:startPosition];
    // Remove from the array
    [allItems removeObject:item];
    // Move to the new location
    [allItems insertObject:item atIndex:endPosition];
    
}

/// Path where this store is store'd
- (NSString *) itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES);
    // On iOS, only one directory is reported. On OSX, multiple directories might be.
    NSString *directory = [documentDirectories firstObject];

    // And now we append our own unique name here
    return [directory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveToDisk {
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:_privateItems toFile:path];
}
@end
