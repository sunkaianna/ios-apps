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
-(void)drawRectangle:(CGContextRef) context : (CGPoint) mappingConstant angle: (double) rotationAngle translateOrRotate: (BOOL)value incrementVal: (int) increment{
    
    CGPoint newPoint;
    newPoint.x = _rectCenter.x*mappingConstant.x - _rectSize/2;
    newPoint.y = _rectCenter.y*mappingConstant.y - _rectSize/2;
    
    //You need to invert the coordinates due to the layout of the context
    //                         x-origin,    y-origin, width, height
    if(value == YES){
    CGContextSaveGState(context);
    //CGRect circle = CGRectMake(0, 0, 15, 15);
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
    CGContextSetRGBFillColor(context, self.red, self.green, self.blue, self.alpha);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextTranslateCTM(context,1*_rectCenter.y*mappingConstant.y , 1*_rectCenter.x*mappingConstant.x );
    CGContextRotateCTM(context, rotationAngle*360*M_PI/180);
    CGContextTranslateCTM(context,-1*_rectCenter.y*mappingConstant.y , -1*_rectCenter.x*mappingConstant.x );
    CGRect rect = CGRectMake(newPoint.y, newPoint.x, _rectSize, _rectSize);
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
    //CGContextSetRGBFillColor(context, self.red, self.green, self.blue, self.alpha);
    CGContextSetLineWidth(context, 5.5);
    //CGContextFillEllipseInRect (context, circle);
    CGContextStrokeRect(context, rect);
    CGContextRestoreGState(context);
    }
    else{
        CGContextSaveGState(context);
        CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
        CGContextSetRGBFillColor(context, self.red, self.green, self.blue, self.alpha);
        CGContextSetLineWidth(context, 0.5);
        
        CGContextTranslateCTM(context,0.01*increment*_rectCenter.y*mappingConstant.y , 0.01*increment*_rectCenter.x*mappingConstant.x );
        CGRect rect = CGRectMake(newPoint.y, newPoint.x, _rectSize, _rectSize);
        CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
        CGContextSetLineWidth(context, 5.5);
        CGContextStrokeRect(context, rect);
        CGContextRestoreGState(context);
    }
}

@end
