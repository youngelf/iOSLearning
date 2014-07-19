//
//  CEVItemStore.m
//  HomeOwner
//
//  Created by Jimi on 7/18/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVItemStore.h"

@interface CEVItemStore()
@property (nonatomic) NSMutableArray *privateItems;

@end

// Stores all the items that we display in a table. This is a singleton.
@implementation CEVItemStore

+ (instancetype) sharedStore {
    static CEVItemStore *store;
    // If the singleton instance exists, return that.
    if (!store) {
        store = [[CEVItemStore alloc] initPrivate];
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
    // Set up the Mutable array
    if (self) {
        [self setPrivateItems:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (NSArray *) allItems {
    return [self privateItems];
}

- (CEVItem *) createItem {
    CEVItem *item = [CEVItem randomItem];
    [[self privateItems] addObject:item];
    return item;
}

@end
