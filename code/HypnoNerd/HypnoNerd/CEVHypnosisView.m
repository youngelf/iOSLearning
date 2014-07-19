//
//  CEVHypnosisView.m
//  Hypnosister
//
//  Created by Jimi on 7/4/14.
//  Copyright (c) 2014 Jimi. All rights reserved.
//

#import "CEVHypnosisView.h"

@interface CEVHypnosisView ()
// The color that the concentric lines will be drawn with.
@property (nonatomic, strong) UIColor *circleColor;
@end

@implementation CEVHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor:[UIColor redColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float lineWidth = 10.0;

    // Drawing code
    CGRect bounds = [self bounds];
    // FInd the center of the bounds
    CGPoint center;
    center.x = bounds.origin.x + (bounds.size.width/2);
    center.y = bounds.origin.y + (bounds.size.height/2);

    // Let's create a clipping path for the gradient: a circle in the middle.
    // Start off by saving the current context because the clipping path applies to everything.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);

    UIBezierPath *clipping = [[UIBezierPath alloc] init];
    [clipping addArcWithCenter:center radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [clipping addClip];
    
    // Gradient as the canvas.
    CGFloat locations [2] = {0.0, 1.0};
    CGFloat components[8] = {
        // Starting color is red: R, G, B, A
        1.0, 0.0, 0.0, 1.0,
        // Ending color is yellow
        1.0, 1.0, 0.0, 1.0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGPoint startPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;

    // The terminal point on the gradient
    CGPoint endPoint;
    endPoint.x = bounds.size.width;
    endPoint.y = bounds.size.height;

    // Draw a linear gradient and restore context.
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(currentContext);

    // Choose the size and path for gray circles
    float radius = ((bounds.size.width + bounds.size.height)/2.0) - lineWidth/2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    while (radius > 0) {
        // Each path is a circle.
        [path addArcWithCenter:center
                        radius:radius
                    startAngle:0.0
                      endAngle:2*M_PI
                     clockwise:YES];
        // Fat gray lines on the path.
        [path setLineWidth:10.0];
        [[self circleColor] setStroke];
        [path stroke];
        CGPoint newStart;
        radius -= 20;
        newStart.x = center.x + radius;
        newStart.y = center.y;
        [path moveToPoint:newStart];
    }
    
    // Draw it in a fraction of the image
    CGRect halfSize;
    halfSize.size.height = bounds.size.height / 2.0;
    halfSize.size.width = bounds.size.width / 2.0;
    halfSize.origin.x = center.x - halfSize.size.width/2.0;
    halfSize.origin.y = center.y - halfSize.size.height/2.0;

    // Drop shadow.
    currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
    [logo drawInRect:halfSize];
    CGContextRestoreGState(currentContext);
}

- (void) setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    NSLog(@"%@ was touched", self);
    // Get a random color
    float red = (arc4random() % 256) / 256.0;
    float green = (arc4random() % 256) / 256.0;
    float blue = (arc4random() % 256) / 256.0;
    [self setCircleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}
@end
