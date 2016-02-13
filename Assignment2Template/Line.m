//
//  Line.m
//  CameraShapes
//
//  Created by Vikrant More on 10/02/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//

#import "Line.h"

@implementation Line

-(id) init{
    self = [super init];
    return self;
}

-(id)initWithCGPoint:(CGPoint)point1 pointTwo:(CGPoint)point2{
    self = [super init];
    
    if(self){
        _firstPoint.x = point1.x;
        _firstPoint.y = point1.y;
        
        _secondPoint.x = point2.x;
        _secondPoint.y = point2.y;
    }
    
    return self;
}

-(void) drawLine:(CGContextRef)context :(CGPoint)mappingConstant{
    
    CGPoint pointOne, pointTwo;
    pointOne.x = _firstPoint.x*mappingConstant.x;
    pointOne.y = _firstPoint.y*mappingConstant.y;
    
    pointTwo.x = _secondPoint.x*mappingConstant.x;
    pointTwo.y = _secondPoint.y*mappingConstant.y;
    
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.alpha);
        CGContextSetLineWidth(context, 5.0);
    CGContextMoveToPoint(context, pointOne.y, pointOne.x);
    CGContextAddLineToPoint(context, pointTwo.y, pointTwo.x);
    CGContextStrokePath(context);
}

@end
