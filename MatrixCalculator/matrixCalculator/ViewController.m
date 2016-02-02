//
//  ViewController.m
//  matrixCalculator
//
//  Created by Vikrant More on 20/01/16.
//  Copyright © 2016 Vikrant More. All rights reserved.
//

#import "ViewController.h"
@import GLKit;

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    _myCalculator = [[CalculatorClass alloc] init];
    
    _r_00.text = @"";
    _r_01.text = @"";
    _r_02.text = @"";
    _r_10.text = @"";
    _r_11.text = @"";
    _r_12.text = @"";
    _r_20.text = @"";
    _r_21.text = @"";
    _r_22.text = @"";
    _ti.text = @"";
    _operation.text = @"";
    _Amat.text = @"[A]";
    _Bmat.text = @"[B]";
    _Cmat.text = @"[c]";
    _Dmat.text = @"[d]";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearButtonPressed:(id)sender {
    _m1_00.text = @"";
    _m1_01.text = @"";
    _m1_02.text = @"";
    _m1_10.text = @"";
    _m1_11.text = @"";
    _m1_12.text = @"";
    _m1_20.text = @"";
    _m1_21.text = @"";
    _m1_22.text = @"";
    
    _m2_00.text = @"";
    _m2_01.text = @"";
    _m2_02.text = @"";
    _m2_10.text = @"";
    _m2_11.text = @"";
    _m2_12.text = @"";
    _m2_20.text = @"";
    _m2_21.text = @"";
    _m2_22.text = @"";
    
    _r_00.text = @"";
    _r_01.text = @"";
    _r_02.text = @"";
    _r_10.text = @"";
    _r_11.text = @"";
    _r_12.text = @"";
    _r_20.text = @"";
    _r_21.text = @"";
    _r_22.text = @"";
    
    _ti.text = @"";
    _operation.text = @"";


}

- (IBAction)invertMatrix:(id)sender {
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];

    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    
    if(!res1 || [appendedStringMatrixA length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

    _ti.text = @" -1 ";
    _operation.text = @"";
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    GLKMatrix3 result;
    bool inv  = [_myCalculator matrixInversion:&m desMatrix:&result];
    
    if(!inv){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                      message:@"Matrix is non-invertible"
                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    _r_00.text = [NSString stringWithFormat:@"%.3f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.3f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.3f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.3f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.3f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.3f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.3f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.3f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.3f", result.m22];
    
    

}


- (IBAction)addMatrix:(id)sender {
//    BOOL y = [[NSScanner scannerWithString:_m1_00.text] scanInt:nil];
//    if(!y){
//        NSLog(@"wrong value, enter integer");
//    }
//    else{

    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                                                                        _m1_10.text, _m1_11.text, _m1_12.text,
                                                                                        _m1_20.text, _m1_21.text, _m1_22.text];
    NSString *appendedStringMatrixB = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m2_00.text, _m2_01.text, _m2_02.text,
                                                                                        _m2_10.text, _m2_11.text, _m2_12.text,
                                                                                        _m2_20.text, _m2_21.text, _m2_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    BOOL res2 = [_myCalculator isANumber:appendedStringMatrixB];
    
    if(!res1 || !res2 || [appendedStringMatrixA length] == 0 || [appendedStringMatrixB length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                      message:@"Matrix elements need to be numbers"
                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKMatrix3  m1 = GLKMatrix3Make(_m2_00.text.intValue, _m2_01.text.intValue,_m2_02.text.intValue,
                                   _m2_10.text.intValue, _m2_11.text.intValue, _m2_12.text.intValue,
                                   _m2_20.text.intValue, _m2_21.text.intValue, _m2_22.text.intValue);
    
    GLKMatrix3 result = [_myCalculator matrixAddition:&m secondMatrix:&m1];
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.2f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.2f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.2f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.2f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.2f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.2f", result.m22];
    }
    
    _ti.text = @"";
    _operation.text = @" + ";
    
}

- (IBAction)subtractMatrix:(id)sender {
    
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];
    NSString *appendedStringMatrixB = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m2_00.text, _m2_01.text, _m2_02.text,
                                       _m2_10.text, _m2_11.text, _m2_12.text,
                                       _m2_20.text, _m2_21.text, _m2_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    BOOL res2 = [_myCalculator isANumber:appendedStringMatrixB];
    
    if(!res1 || !res2 || [appendedStringMatrixA length] == 0 || [appendedStringMatrixB length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKMatrix3  m1 = GLKMatrix3Make(_m2_00.text.intValue, _m2_01.text.intValue,_m2_02.text.intValue,
                                    _m2_10.text.intValue, _m2_11.text.intValue, _m2_12.text.intValue,
                                    _m2_20.text.intValue, _m2_21.text.intValue, _m2_22.text.intValue);
    
    
    GLKMatrix3 result = [_myCalculator matrixSubtraction:&m secondMatrix:&m1];
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.2f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.2f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.2f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.2f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.2f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.2f", result.m22];
    
    _ti.text = @"";
    _operation.text = @" - ";
}

- (IBAction)multiplyMatrix:(id)sender {
    
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];
    NSString *appendedStringMatrixB = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m2_00.text, _m2_01.text, _m2_02.text,
                                       _m2_10.text, _m2_11.text, _m2_12.text,
                                       _m2_20.text, _m2_21.text, _m2_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    BOOL res2 = [_myCalculator isANumber:appendedStringMatrixB];
    
    if(!res1 || !res2 || [appendedStringMatrixA length] == 0 || [appendedStringMatrixB length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKMatrix3  m1 = GLKMatrix3Make(_m2_00.text.intValue, _m2_01.text.intValue,_m2_02.text.intValue,
                                    _m2_10.text.intValue, _m2_11.text.intValue, _m2_12.text.intValue,
                                    _m2_20.text.intValue, _m2_21.text.intValue, _m2_22.text.intValue);
    
    
    GLKMatrix3 result = [_myCalculator matrixMultiplication:&m secondMatrix:&m1];
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.2f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.2f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.2f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.2f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.2f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.2f", result.m22];
    
    _ti.text = @"";
    _operation.text = @" * ";
}

- (IBAction)elementDivideMatrix:(id)sender {
    
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];
    NSString *appendedStringMatrixB = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m2_00.text, _m2_01.text, _m2_02.text,
                                       _m2_10.text, _m2_11.text, _m2_12.text,
                                       _m2_20.text, _m2_21.text, _m2_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    BOOL res2 = [_myCalculator isANumber:appendedStringMatrixB];
    
    if(!res1 || !res2 || [appendedStringMatrixA length] == 0 || [appendedStringMatrixB length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKMatrix3  m1 = GLKMatrix3Make(_m2_00.text.intValue, _m2_01.text.intValue,_m2_02.text.intValue,
                                    _m2_10.text.intValue, _m2_11.text.intValue, _m2_12.text.intValue,
                                    _m2_20.text.intValue, _m2_21.text.intValue, _m2_22.text.intValue);
    
    
    GLKMatrix3 result = [_myCalculator elementDivideMatrix:&m secondMatrix:&m1];
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.2f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.2f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.2f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.2f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.2f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.2f", result.m22];
    
    _ti.text = @"";
    _operation.text = @" ./ ";
    
}

- (IBAction)elementMultiplyMatrix:(id)sender {
    
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];
    NSString *appendedStringMatrixB = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m2_00.text, _m2_01.text, _m2_02.text,
                                       _m2_10.text, _m2_11.text, _m2_12.text,
                                       _m2_20.text, _m2_21.text, _m2_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    BOOL res2 = [_myCalculator isANumber:appendedStringMatrixB];
    
    if(!res1 || !res2 || [appendedStringMatrixA length] == 0 || [appendedStringMatrixB length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKMatrix3  m1 = GLKMatrix3Make(_m2_00.text.intValue, _m2_01.text.intValue,_m2_02.text.intValue,
                                    _m2_10.text.intValue, _m2_11.text.intValue, _m2_12.text.intValue,
                                    _m2_20.text.intValue, _m2_21.text.intValue, _m2_22.text.intValue);
    
    
    GLKMatrix3 result = [_myCalculator elementMultiplyMatrix:&m secondMatrix:&m1];
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.2f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.2f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.2f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.2f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.2f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.2f", result.m22];
    
    _ti.text = @"";
    _operation.text = @" .*";
}

- (IBAction)determinantMatrix:(id)sender {
    
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];

    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];

    
    if(!res1 || [appendedStringMatrixA length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    double result = [_myCalculator matrixDeterminant:&m];
    
    _r_11.text = [NSString stringWithFormat:@"%.2f", result];
    _r_00.text = [NSString stringWithFormat:@""];
    _r_01.text = [NSString stringWithFormat:@""];
    _r_02.text = [NSString stringWithFormat:@""];
    _r_10.text = [NSString stringWithFormat:@""];

    _r_12.text = [NSString stringWithFormat:@""];
    _r_20.text = [NSString stringWithFormat:@""];
    _r_21.text = [NSString stringWithFormat:@""];
    _r_22.text = [NSString stringWithFormat:@""];

    _ti.text = @" det ";
    _operation.text = @"";

}

- (IBAction)dotProductMatrix:(id)sender {
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                                                                        _m2_00.text, _m2_10.text, _m2_20.text];
 
    NSString *appendedStringMatrixEmpty = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@", _m1_10.text, _m1_11.text, _m1_12.text,
                                                                                      _m1_20.text, _m1_21.text, _m1_22.text,
                                                                                      _m2_01.text, _m2_02.text, _m2_11.text,
                                                                                      _m2_12.text, _m2_21.text, _m2_22.text];

    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
  
    if(!res1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if([appendedStringMatrixEmpty length] != 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"Matrix order not 3x1. Enter column matrices"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ignore"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    GLKVector3  m1 = GLKVector3Make(_m1_00.text.intValue, _m1_01.text.intValue, _m1_02.text.intValue);
    GLKVector3  m2 = GLKVector3Make(_m2_00.text.intValue, _m2_10.text.intValue, _m2_20.text.intValue);
    
    double result = [_myCalculator dotProductVector:&m1 secondMatrix:&m2];
    
    _ti.text = @"";
    _operation.text = @".";
    
    _r_11.text = [NSString stringWithFormat:@"%.2f", result];
    _r_01.text = [NSString stringWithFormat:@""];
    _r_02.text = [NSString stringWithFormat:@""];
    _r_10.text = [NSString stringWithFormat:@""];
    _r_12.text = [NSString stringWithFormat:@""];
    _r_20.text = [NSString stringWithFormat:@""];
    _r_21.text = [NSString stringWithFormat:@""];
    _r_22.text = [NSString stringWithFormat:@""];



    
}

- (IBAction)crossProductMatrix:(id)sender {
   
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m2_00.text, _m2_10.text, _m2_20.text];
    
    NSString *appendedStringMatrixEmpty = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@", _m1_10.text, _m1_11.text, _m1_12.text,
                                           _m1_20.text, _m1_21.text, _m1_22.text,
                                           _m2_01.text, _m2_02.text, _m2_11.text,
                                           _m2_12.text, _m2_21.text, _m2_22.text];
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    
    
    
    if(!res1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if([appendedStringMatrixEmpty length] != 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"Matrix order not 3x1. Enter column matrices"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ignore"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    GLKVector3  m1 = GLKVector3Make(_m1_00.text.intValue, _m1_01.text.intValue, _m1_02.text.intValue);
    GLKVector3  m2 = GLKVector3Make(_m2_00.text.intValue, _m2_10.text.intValue, _m2_20.text.intValue);
    
    GLKVector3 result = [_myCalculator crossProductVector:&m1 secondMatrix:&m2];
    
    
    _ti.text = @"";
    _operation.text = @"X";
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.x];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.y];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.z];
    _r_01.text = [NSString stringWithFormat:@""];
    _r_02.text = [NSString stringWithFormat:@""];
    _r_11.text = [NSString stringWithFormat:@""];
    _r_12.text = [NSString stringWithFormat:@""];
    _r_21.text = [NSString stringWithFormat:@""];
    _r_22.text = [NSString stringWithFormat:@""];


}

- (IBAction)threeCrossOneMultiplyMatrix:(id)sender {
    
  
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];
    NSString *appendedStringMatrixB = [NSString stringWithFormat:@"%@%@%@", _m2_00.text,_m2_10.text,_m2_20.text];
    NSString *appendedStringMatrixC = [NSString stringWithFormat:@"%@%@%@%@%@%@", _m2_01.text, _m2_02.text, _m2_11.text,
                                                                                  _m2_12.text, _m2_21.text, _m2_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];
    BOOL res2 = [_myCalculator isANumber:appendedStringMatrixB];
    
    
    if(!res1 || !res2 || [appendedStringMatrixA length] == 0 || [appendedStringMatrixB length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if([appendedStringMatrixC length] != 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"Matrix order not 3x1"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ignore"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    
    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKVector3  m2 = GLKVector3Make(_m2_00.text.intValue, _m2_10.text.intValue, _m2_20.text.intValue);
    
    GLKVector3 result = [_myCalculator threeCrossOneMultiplyMatrix:&m secondMatrix:&m2];
    
    
    _ti.text = @"";
    _operation.text = @" 3x1 *";
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.x];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.y];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.z];
    _r_01.text = [NSString stringWithFormat:@""];
    _r_02.text = [NSString stringWithFormat:@""];
    _r_11.text = [NSString stringWithFormat:@""];
    _r_12.text = [NSString stringWithFormat:@""];
    _r_21.text = [NSString stringWithFormat:@""];
    _r_22.text = [NSString stringWithFormat:@""];

}

- (IBAction)randomizeAMatrix:(id)sender {
    
    //NSInteger randomA_00 = arc4random()%100;
    _m1_00.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_01.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_02.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_10.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_11.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_12.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_20.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_21.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m1_22.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    
}

- (IBAction)randomizeBMatrix:(id)sender {
    _m2_00.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_01.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_02.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_10.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_11.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_12.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_20.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_21.text = [NSString stringWithFormat:@"%u", arc4random()%15];
    _m2_22.text = [NSString stringWithFormat:@"%u", arc4random()%15];
}


- (IBAction)transposeMatrix:(id)sender {
    
    
    
    NSString *appendedStringMatrixA = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", _m1_00.text, _m1_01.text, _m1_02.text,
                                       _m1_10.text, _m1_11.text, _m1_12.text,
                                       _m1_20.text, _m1_21.text, _m1_22.text];
    
    BOOL res1 = [_myCalculator isANumber:appendedStringMatrixA];

    
    if(!res1|| [appendedStringMatrixA length] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"Matrix elements need to be numbers"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{

    GLKMatrix3  m = GLKMatrix3Make(_m1_00.text.intValue, _m1_01.text.intValue,_m1_02.text.intValue,
                                   _m1_10.text.intValue, _m1_11.text.intValue, _m1_12.text.intValue,
                                   _m1_20.text.intValue, _m1_21.text.intValue, _m1_22.text.intValue);
    
    GLKMatrix3 result = [_myCalculator matrixTranspose:&m];
    
    _r_00.text = [NSString stringWithFormat:@"%.2f", result.m00];
    _r_01.text = [NSString stringWithFormat:@"%.2f", result.m01];
    _r_02.text = [NSString stringWithFormat:@"%.2f", result.m02];
    _r_10.text = [NSString stringWithFormat:@"%.2f", result.m10];
    _r_11.text = [NSString stringWithFormat:@"%.2f", result.m11];
    _r_12.text = [NSString stringWithFormat:@"%.2f", result.m12];
    _r_20.text = [NSString stringWithFormat:@"%.2f", result.m20];
    _r_21.text = [NSString stringWithFormat:@"%.2f", result.m21];
    _r_22.text = [NSString stringWithFormat:@"%.2f", result.m22];
    }
    
    _ti.text = @"T";
    _operation.text = @"";
}



@end


