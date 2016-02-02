//
//  CalculatorClass.m
//  matrixCalculator
//

#import "CalculatorClass.h"
@import GLKit;

@implementation CalculatorClass

-(id) init{
    self  = [super init];
    return self;
}
//
//-(GLKMatrix3) matrixInversion:(GLKMatrix3*)sourceM{
//    BOOL inv;
//    _destM = GLKMatrix3Invert(*sourceM, &inv);
//  
//    return _destM;
//}


-(BOOL) isANumber: (NSString*)appendedString{
    
    NSRange r = [appendedString rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    //if(!(r.location == NSNotFound))
    //    NSLog(@"wrong value, enter integer");
    return (r.location == NSNotFound);
}


-(BOOL) matrixInversion:(GLKMatrix3*)sourceM desMatrix: (GLKMatrix3*)destM{
    //BOOL inv;
    
    _destM = GLKMatrix3Invert(*sourceM, &_isInverse);
    //destM = &_destM;
    destM->m00 = _destM.m00;
    destM->m01 = _destM.m01;
    destM->m02 = _destM.m02;
    destM->m10 = _destM.m10;
    destM->m11 = _destM.m11;
    destM->m12 = _destM.m12;
    destM->m20 = _destM.m20;
    destM->m21 = _destM.m21;
    destM->m22 = _destM.m22;

    
    return _isInverse;
}

-(GLKMatrix3) matrixTranspose:(GLKMatrix3*)sourceM{
    _destM = GLKMatrix3Transpose(*sourceM);
    return _destM;
}

-(GLKMatrix3) matrixAddition:(GLKMatrix3 *)sourceM1 secondMatrix:(GLKMatrix3 *)sourceM2{
    _destM = GLKMatrix3Add(*sourceM1,*sourceM2);
    return _destM;
}

-(GLKMatrix3) matrixSubtraction:(GLKMatrix3 *)sourceM1 secondMatrix:(GLKMatrix3 *)sourceM2{
    _destM = GLKMatrix3Subtract(*sourceM1,*sourceM2);
    return _destM;
}

-(GLKMatrix3) matrixMultiplication:(GLKMatrix3 *)sourceM1 secondMatrix:(GLKMatrix3 *)sourceM2{
    _destM = GLKMatrix3Multiply(*sourceM1,*sourceM2);
    return _destM;
}

-(GLKMatrix3) elementDivideMatrix:(GLKMatrix3 *)sourceM1 secondMatrix:(GLKMatrix3 *)sourceM2{
    _destM = GLKMatrix3Make(sourceM1->m00 / sourceM2->m00, sourceM1->m01 / sourceM2->m01, sourceM1->m02 / sourceM2->m02,
                            sourceM1->m10 / sourceM2->m10, sourceM1->m11 / sourceM2->m11, sourceM1->m12 / sourceM2->m12,
                            sourceM1->m20 / sourceM2->m20, sourceM1->m21 / sourceM2->m21, sourceM1->m22 / sourceM2->m22);
    return _destM;
}

-(GLKMatrix3) elementMultiplyMatrix:(GLKMatrix3 *)sourceM1 secondMatrix:(GLKMatrix3 *)sourceM2{
    _destM = GLKMatrix3Make(sourceM1->m00 * sourceM2->m00, sourceM1->m01 * sourceM2->m01, sourceM1->m02 * sourceM2->m02,
                            sourceM1->m10 * sourceM2->m10, sourceM1->m11 * sourceM2->m11, sourceM1->m12 * sourceM2->m12,
                            sourceM1->m20 * sourceM2->m20, sourceM1->m21 * sourceM2->m21, sourceM1->m22 * sourceM2->m22);
    return _destM;
}

-(double) matrixDeterminant:(GLKMatrix3 *)sourceM{
    
    _determinant = sourceM->m00*(sourceM->m11 * sourceM->m22 - sourceM->m12 * sourceM->m21)
                   - sourceM->m01*(sourceM->m10*sourceM->m22 - sourceM->m12 * sourceM->m20)
                   + sourceM->m02*(sourceM->m10*sourceM->m21 - sourceM->m11 * sourceM->m20);
    return _determinant;
}

-(GLKVector3) threeCrossOneMultiplyMatrix:(GLKMatrix3 *)sourceM secondMatrix:(GLKVector3 *)sourceM2{
    _product = GLKVector3Make(sourceM->m00*sourceM2->x + sourceM->m01*sourceM2->y + sourceM->m02*sourceM2->z,
                              sourceM->m10*sourceM2->x + sourceM->m11*sourceM2->y + sourceM->m12*sourceM2->z,
                              sourceM->m20*sourceM2->x + sourceM->m21*sourceM2->y + sourceM->m22*sourceM2->z);
    return _product;
}

-(double) dotProductVector:(GLKVector3 *)sourceM secondMatrix:(GLKVector3 *)sourceM2{
    _dotProduct = GLKVector3DotProduct(*sourceM, *sourceM2);
    return _dotProduct;
}

-(GLKVector3) crossProductVector:(GLKVector3 *)sourceM secondMatrix:(GLKVector3 *)sourceM2{
    _product = GLKVector3CrossProduct(*sourceM, *sourceM2);
    return _product;
}











@end
