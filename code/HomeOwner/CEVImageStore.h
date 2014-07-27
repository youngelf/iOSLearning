//
//  CEVImageStore.h
//  HomeOwner
//
//  Created by Vikram Aggarwal on 7/25/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEVImageStore : NSObject

+ (instancetype) sharedStore;

- (void) setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *) getImageForKey:(NSString *)key;
- (void) deleteImageForKey:(NSString *)key;

@end
