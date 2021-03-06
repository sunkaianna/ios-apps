//
//  Line.h
//  CameraShapes
//
//  Created by Vikrant More on 10/02/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#include <math.h>
#import "Shape2D.h"


#ifndef Line_h
#define Line_h
@interface Line : Shape2D

@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint secondPoint;


-(id)init;
-(id)initWithCGPoint : (CGPoint) point1 pointTwo : (CGPoint) point2;
-(void)drawLine:(CGContextRef) context : (CGPoint) mappingConstant;

@end
#endif
