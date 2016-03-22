//
//  Circle.m
//  
//
//  Created on 2/1/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//

#import "Circle.h"

@implementation Circle

#pragma mark - Init methods
//Standard init method. Sets circle center to (0,0) and size to 20
-(id)init {
    self = [super init];
    
    if (self) {
        _circleCenter.x = 0.0f;
        _circleCenter.y = 0.0f;
        _circleSize = 20.0f;
    }
    return self;
}

//Initialize a Circle object given a center point
-(id)initWithCGPoint : (CGPoint) point {
    
    self = [super init];
    
    if (self) {
        _circleCenter.x = point.x;
        _circleCenter.y = point.y;
        _circleSize = 20.0f;
    }
    return self;
}

#pragma mark - Draw circle
//Draw a circle in the specified location
-(void)drawCircle:(CGContextRef) context : (CGPoint) mappingConstant {
    
    CGPoint newPoint;
    newPoint.x = _circleCenter.x*mappingConstant.x;
    newPoint.y = _circleCenter.y*mappingConstant.y;
    
    //You need to invert the coordinates due to the layout of the context
    //                         x-origin,    y-origin, width, height
    CGRect circle = CGRectMake(newPoint.y - _circleSize/2.0, newPoint.x - _circleSize/2.0, _circleSize, _circleSize);
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
    CGContextSetRGBFillColor(context, self.red, self.green, self.blue, self.alpha);
    CGContextSetLineWidth(context, 3);
    CGContextStrokeEllipseInRect (context, circle);
}


@end
