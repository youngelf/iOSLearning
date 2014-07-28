//
//  CEVDrawView.m
//  TouchTracker
//
//  Created by Vikram Aggarwal on 7/26/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVDrawView.h"
#import "CEVLine.h"

@interface CEVDrawView()
@property (nonatomic, strong) CEVLine *currentLine;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@end

@implementation CEVDrawView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFinishedLines:[[NSMutableArray alloc] init]];
        [self setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}

// Stroke a line with a Bezier Path
- (void) strokeLine:(CEVLine *)line {
    // Create a Bezier Path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path setLineWidth:10];
    [path setLineCapStyle:kCGLineCapRound];
    
    [path moveToPoint:[line begin]];
    [path addLineToPoint:[line end]];
    [path stroke];
}

// Refresh a rectangle with all the lines
- (void)drawRect:(CGRect)rect {
    // Finished lines are shown in black.
    [[UIColor blackColor] set];
    // Iterate through finished lines and draw them
    for (CEVLine *line in [self finishedLines]) {
        [self strokeLine:line];
    }
    
    // Now change the color to red and draw the current line
    [[UIColor redColor] set];
    [self strokeLine:[self currentLine]];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self setCurrentLine:[[CEVLine alloc] init]];

    // The location of the touch in our view.
    CGPoint location = [touch locationInView:self];
    [[self currentLine] setBegin:location];
    [[self currentLine] setEnd:location];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Update the end point with this event
    [[self currentLine] setEnd:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Add the current line to the array
    [[self finishedLines] addObject:[self currentLine]];
    [self setCurrentLine:nil];
    
    [self setNeedsDisplay];
}

@end
