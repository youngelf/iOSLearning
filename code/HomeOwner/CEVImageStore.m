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
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            store = [[CEVImageStore alloc] initPrivate];
        });
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
        // Look out for low-memory warnings
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCache:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [[self imageDict] setObject:image forKey:key];

    // And save this to disk
    NSString *path = [self imagePathForKey:key];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [imageData writeToFile:path atomically:true];
}

- (UIImage *)getImageForKey:(NSString *)key {
    // Try getting it from the dictionary.
    UIImage *image = [[self imageDict] objectForKey:key];
    // If it doesn't exist, try getting it from the disk
    if (!image) {
        NSString *path = [self imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:path];
        // Check if something was available
        if (image) {
            // Yes, then store it to the dictionary
            [[self imageDict] setObject:image forKey:key];
        }
    }
    return image;
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) { return; }
    [[self imageDict] removeObjectForKey:key];

    // And also remove it from disk
    NSString *path = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (NSString *) imagePathForKey: (NSString *) key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES);
    // On iOS, only one directory is reported. On OSX, multiple directories might be.
    NSString *directory = [documentDirectories firstObject];

    // And now we append our own unique name here
    return [directory stringByAppendingPathComponent:key];
}

- (void)clearCache: (NSNotification *) sender {
    NSLog(@"Flushhhhhh!");
    [[self imageDict] removeAllObjects];
}

@end
