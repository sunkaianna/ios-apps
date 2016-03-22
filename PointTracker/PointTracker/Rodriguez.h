//
//  Rodriguez.h
//  HorizonLine
//
//  Created by Vikrant More on 11/03/16.
//  Copyright © 2016 Vikrant More. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Rodriguez : NSObject

-(GLKMatrix3) skewSym : (GLKVector3) omega;
-(double) magVector : (GLKVector3) vector;
-(GLKMatrix3) fullRodriguez : (GLKVector3) deltaRotation;
-(GLKVector3) pixelCoordsToCamera : (CGPoint) point;
-(CGPoint) cameraCoordsToPixel : (GLKVector3) point;
-(GLKMatrix3) smallAngleRodriguez : (GLKVector3) deltaRotation;

@end
