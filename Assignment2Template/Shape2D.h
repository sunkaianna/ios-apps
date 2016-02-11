//
//  Shape2D.h
//  Assignment2Template
//
//  Created on 2/1/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#include <math.h>

#ifndef Shape2D_h
#define Shape2D_h
@interface Shape2D : NSObject

//Variables
@property (nonatomic) CGColorRef color;
@property (nonatomic) double degreesToRotate;

//RGBA default values for an object
@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;
@property (nonatomic) CGFloat alpha;


//Methods
-(id)init;
+(CGPoint)rotateVector:(GLKVector3) vectorToRotate : (double)degreesToRotate;

@end
#endif /* Shape2D_h */
