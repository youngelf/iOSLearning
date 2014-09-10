//
//  BNRItem.m
//  RandomItems
//
//  Created by John Gallagher on 1/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "CEVItem.h"

@implementation CEVItem

+ (instancetype)randomItem
{
    // Create an immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny", @"Dusty", @"Crooked", @"Sharp"];

    // Create an immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac", @"Linux", @"Windows"];

    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];

    // Note that NSInteger is not an object, but a type definition
    // for "long"

    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectiveList[adjectiveIndex],
                            randomNounList[nounIndex]];

    int randomValue = arc4random() % 100;

    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];

    CEVItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];

    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];

    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        // Set _dateCreated to the current date and time
        _dateCreated = [[NSDate alloc] init];
        
        // Create a unique UUID string.
        _imageTag = [[[NSUUID alloc] init] UUIDString];
    }

    // Return the address of the newly initialized object
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (void)setItemName:(NSString *)str
{
    _itemName = str;
}

- (NSString *)itemName
{
    return _itemName;
}

- (void)setSerialNumber:(NSString *)str
{
    _serialNumber = str;
}

- (NSString *)serialNumber
{
    return _serialNumber;
}

- (void)setValueInDollars:(int)v
{
    _valueInDollars = v;
}

- (int)valueInDollars
{
    return _valueInDollars;
}

- (NSDate *)dateCreated
{
    return _dateCreated;
}

- (NSString *)description
{
    NSString *descriptionString =
        [[NSString alloc] initWithFormat:@"%@: $%d, (%@) recorded on %@",
         self.itemName,
         self.valueInDollars,
         self.serialNumber,
         self.dateCreated];
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self itemName] forKey:@"itemName"];
    [aCoder encodeInteger:[self valueInDollars] forKey:@"valueInDollars"];
    [aCoder encodeObject:[self serialNumber] forKey:@"serialNumber"];
    [aCoder encodeObject:[self dateCreated] forKey:@"dateCreated"];
    [aCoder encodeObject:[self imageTag] forKey:@"imageTag"];
    [aCoder encodeObject:[self thumbnail] forKey:@"thumbnail"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [CEVItem alloc];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _valueInDollars = [aDecoder decodeIntegerForKey:@"valueInDollars"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _imageTag = [aDecoder decodeObjectForKey:@"imageTag"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }
    return self;
}

- (void) setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    
    // Size of the thumbnail
    CGRect tNail = CGRectMake(0, 0, 40, 40);
    
    // Figure out the scaling factor so we preserve the original aspect ratio
    float ratio = MAX(tNail.size.width/origImageSize.width,
                      tNail.size.height/origImageSize.height);
    
    // Create a transparent bitmap context with the scaling factor
    UIGraphicsBeginImageContextWithOptions(tNail.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tNail cornerRadius:5.0];
    // Drawing clipped to this path
    [path addClip];
    
    // Center the image in this thumbnail square
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    
    projectRect.origin.x = (tNail.size.width - projectRect.size.width) / 2;
    projectRect.origin.y = (tNail.size.height - projectRect.size.height) / 2;
    // Draw the image in it.
    [image drawInRect:projectRect];
    
    // Get the image from the context and save it.
    UIImage *thumbNail = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:thumbNail];
    
    // Clean up image resources
    UIGraphicsEndImageContext();
}

@end
