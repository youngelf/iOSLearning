//
//  CEVImageStore.m
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/25/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVImageStore.h"

@interface CEVImageStore()
@property (strong, nonatomic) NSMutableDictionary *imageDict;
@end

// Stores all images as they come by.
@implementation CEVImageStore

+ (instancetype)sharedStore {
    static CEVImageStore *store;
    if (!store) {
        store = [[CEVImageStore alloc] initPrivate];
    }
    return store;
}

- (id)init {
    // Don't allow instantiation
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use [CEVImageStore sharedStore]"
                                 userInfo:nil];
}

- (instancetype) initPrivate {
    self = [super init];
    if (self) {
        _imageDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [[self imageDict] setObject:image forKey:key];
}

- (UIImage *)getImageForKey:(NSString *)key {
    return [[self imageDict] objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) { return; }
    [[self imageDict] removeObjectForKey:key];
}

@end
