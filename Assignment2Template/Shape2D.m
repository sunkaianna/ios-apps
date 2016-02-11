//
//  Shape2D.m
//  Assignment2Template
//
//  Created on 2/1/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//

#import "Shape2D.h"

@implementation Shape2D

//Standard init method
-(id)init {
    self = [super init];
    
    //Initialize variables here
    if (self) {
        
        _degreesToRotate = 0.0;
        _color = [[UIColor greenColor] CGColor];
        
        //RGBA values for yellow
        _red = 1.0f;
        _green = 0.843f;
        _blue = 0.0f;
        _alpha = 1.0f;
    
    }
    return self;
}



//Class method: rotate vector
+(CGPoint)rotateVector:(GLKVector3) vectorToRotate : (double)degreesToRotate {
    
    CGPoint newVector;
    GLKMatrix3 rotationMatrix;
    
    //TODO: Do the matrix operation
    rotationMatrix.m00 = 0.0f;
    
 
   
    
    
    
    
    
    newVector.x = vectorToRotate.x;
    newVector.y = vectorToRotate.y;
    
    return newVector;
}

@end
