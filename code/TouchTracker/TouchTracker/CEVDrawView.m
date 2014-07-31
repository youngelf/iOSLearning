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
// Multi-touch will produce many lines.
@property (nonatomic, strong) NSMutableDictionary *currentLines;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, weak) CEVLine *selectedLine;
@end

@implementation CEVDrawView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCurrentLines:[[NSMutableDictionary alloc] init]];
        [self setFinishedLines:[[NSMutableArray alloc] init]];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // Recognize double taps
        UITapGestureRecognizer *doubleTapper =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(doubleTap:)];
        [doubleTapper setNumberOfTapsRequired:2];
        [doubleTapper setDelaysTouchesBegan:YES];
        [self addGestureRecognizer:doubleTapper];
        
        // Single tap recognizer
        UITapGestureRecognizer *singleTapper =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(singleTap:)];
        [singleTapper setDelaysTouchesBegan:YES];
        [singleTapper requireGestureRecognizerToFail:doubleTapper];
        [self addGestureRecognizer:singleTapper];

    }
    return self;
}

- (void) doubleTap: (UIGestureRecognizer *)gs {
    NSLog(@"Double tap received.");
    // Clear the screen
    [[self currentLines] removeAllObjects];
    [[self finishedLines] removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void) singleTap: (UIGestureRecognizer *) gs {
    NSLog(@"Single tap");
    
    // Check if a point is close enough
    [self setSelectedLine:[self lineAtPoint:[gs locationInView:self]]];
    [self setNeedsDisplay];
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
    for (NSValue *key in [self currentLines]) {
        [self strokeLine:[[self currentLines] objectForKey:key]];
    }
    
    // The selected line is drawn in green
    if ([self selectedLine]) {
        [[UIColor greenColor] set];
        [self strokeLine:[self selectedLine]];
    }
}

/** Find a line close enough to the given point */
- (CEVLine *) lineAtPoint:(CGPoint) point {
    for (CEVLine *l in [self finishedLines]) {
        CGPoint start = [l begin];
        CGPoint end = [l end];
        // Check a few points on the line
        for (float t=0.0; t<1.0; t+= 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, return this line
            if (hypot(x-point.x, y-point.y) < 20.0) {
                return l;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // Start a new line.
        CEVLine *line = [[CEVLine alloc] init];
        
        // The location of the touch in our view.
        CGPoint location = [touch locationInView:self];
        [line setBegin:location];
        [line setEnd:location];

        NSValue *key = [NSValue valueWithNonretainedObject:touch];

        // And add it to our list.
        [[self currentLines] setObject:line forKey:key];
    }
    // Update this view, please.
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Update the end point with this event
    for (UITouch *touch in touches) {
        // Get the element to modify
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        [[[self currentLines] objectForKey:key] setEnd:[touch locationInView:self]];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Add the current line to the array
    for (UITouch *touch in touches) {
        // Remove from the current lines.
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        CEVLine *line = [[self currentLines] objectForKey:key];
        [[self currentLines] removeObjectForKey:key];
        // Add to the finished lines.
        [[self finishedLines] addObject:line];
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Remove all current state and don't add these movements to the lines
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        [[self currentLines] removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

@end
