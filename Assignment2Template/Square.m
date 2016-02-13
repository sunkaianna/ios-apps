//
//  Square.m
//  CameraShapes
//
//  Created by Vikrant More on 11/02/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//

#import "Square.h"

@implementation Square

-(id)initWithCGPoint : (CGPoint) centre {
    
    self = [super init];
    
    if (self) {
        _rectCenter.x = centre.x;
        _rectCenter.y = centre.y;
        _rectSize = 400.0f;
    }
    return self;
}


//Draw a rectangle in the specified location
-(void)drawRectangle:(CGContextRef) context : (CGPoint) mappingConstant {
    
    CGPoint newPoint;
    newPoint.x = _rectCenter.x*mappingConstant.x - _rectSize/2;
    newPoint.y = _rectCenter.y*mappingConstant.y - _rectSize/2;
    
    //You need to invert the coordinates due to the layout of the context
    //                         x-origin,    y-origin, width, height
    CGRect rect = CGRectMake(newPoint.y, newPoint.x, _rectSize, _rectSize);
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
    //CGContextSetRGBFillColor(context, self.red, self.green, self.blue, self.alpha);
    CGContextSetLineWidth(context, 5.5);
    //CGContextFillRect (context, rect);
    CGContextStrokeRect(context, rect);
}

@end
