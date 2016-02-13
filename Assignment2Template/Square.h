//
//  Square.h
//  CameraShapes
//
//  Created by Vikrant More on 11/02/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#include <math.h>
#import "Shape2D.h"

#ifndef Square_h
#define Square_h

@interface Square : Shape2D

@property (nonatomic) CGPoint rectCenter;
@property (nonatomic) CGFloat rectSize;

-(id)initWithCGPoint : (CGPoint) centre;
-(void)drawRectangle:(CGContextRef) context : (CGPoint) mappingConstant;


@end
#endif