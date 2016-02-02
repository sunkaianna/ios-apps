//
//  CalculatorClass.h
//  matrixCalculator
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface CalculatorClass : NSObject


@property GLKMatrix3 destM;
@property GLKVector3 product;
@property double determinant;
@property double dotProduct;
@property BOOL isInverse;


-(id) init;
//-(GLKMatrix3) matrixInversion: (GLKMatrix3*)sourceM;
-(BOOL) isANumber: (NSString*)appendedString;
-(BOOL) matrixInversion: (GLKMatrix3*)sourceM desMatrix: (GLKMatrix3*)destM;
-(GLKMatrix3) matrixTranspose: (GLKMatrix3*)sourceM;
-(double) matrixDeterminant: (GLKMatrix3*)sourceM;
-(GLKMatrix3) matrixAddition: (GLKMatrix3*)sourceM1 secondMatrix:(GLKMatrix3*)sourceM2;
-(GLKMatrix3) matrixSubtraction: (GLKMatrix3*)sourceM secondMatrix:(GLKMatrix3*)sourceM2;
-(GLKMatrix3) matrixMultiplication: (GLKMatrix3*)sourceM secondMatrix:(GLKMatrix3*)sourceM2;
-(GLKMatrix3) elementDivideMatrix: (GLKMatrix3*)sourceM secondMatrix:(GLKMatrix3*)sourceM2;
-(GLKMatrix3) elementMultiplyMatrix: (GLKMatrix3*)sourceM secondMatrix:(GLKMatrix3*)sourceM2;
-(GLKVector3) threeCrossOneMultiplyMatrix: (GLKMatrix3*)sourceM secondMatrix:(GLKVector3*)sourceM2;
-(double) dotProductVector: (GLKVector3*)sourceM secondMatrix:(GLKVector3*)sourceM2;
-(GLKVector3) crossProductVector: (GLKVector3*)sourceM secondMatrix:(GLKVector3*)sourceM2;

@end
