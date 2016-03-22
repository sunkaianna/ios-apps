//
//  Rodriguez.m
//  HorizonLine
//
//  Created by Vikrant More on 11/03/16.
//  Copyright © 2016 Vikrant More. All rights reserved.
//

#import "Rodriguez.h"

#define focalLength 571.42

@implementation Rodriguez


-(GLKMatrix3) skewSym : (GLKVector3) omega{
   
    return GLKMatrix3Make(0, -omega.z, omega.y,
                          omega.z, 0, -omega.x,
                          -omega.y, omega.x, 0);
}
-(double) magVector : (GLKVector3) vector{
   
    return sqrt((pow(vector.x, 2.0))+pow(vector.y, 2.0)+pow(vector.z, 2.0));
}

-(GLKMatrix3) fullRodriguez : (GLKVector3) deltaRotation{
  

    GLKMatrix3 skew = [self skewSym:deltaRotation];

    double mag = [self magVector:deltaRotation];
   
    double temp1 = sin(mag)/mag;
    
    GLKMatrix3 firstTerm = GLKMatrix3Make(skew.m00*temp1, skew.m01*temp1, skew.m02*temp1,
                                          skew.m10*temp1, skew.m11*temp1, skew.m12*temp1,
                                          skew.m20*temp1, skew.m21*temp1, skew.m22*temp1);
    
    GLKMatrix3 skewSquare = GLKMatrix3Multiply(skew, skew);

    double temp2 = (1 - cos(mag))/(mag*mag);
    GLKMatrix3 secondTerm = GLKMatrix3Make(skewSquare.m00*temp2, skewSquare.m01*temp2, skewSquare.m02*temp2,
                                           skewSquare.m10*temp2, skewSquare.m11*temp2, skewSquare.m12*temp2,
                                           skewSquare.m20*temp2, skewSquare.m21*temp2, skewSquare.m22*temp2);

    GLKMatrix3 result = GLKMatrix3Add(GLKMatrix3Subtract(GLKMatrix3Identity, firstTerm), secondTerm);
    return result;
}

-(CGPoint) cameraCoordsToPixel : (GLKVector3) point{
    
    return CGPointMake((focalLength*point.x/point.z)+240, (focalLength*point.y/point.z)+320);
}

-(GLKVector3) pixelCoordsToCamera : (CGPoint) centre{
   
    GLKVector3 cameraCoords = GLKVector3Make(centre.x - 240, centre.y - 320, focalLength);
    return cameraCoords;
}

-(GLKMatrix3) smallAngleRodriguez:(GLKVector3)deltaRotation{
   
    return GLKMatrix3Subtract(GLKMatrix3Identity, [self skewSym:deltaRotation]);
}

@end
