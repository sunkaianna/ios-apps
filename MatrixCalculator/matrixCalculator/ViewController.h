//
//  ViewController.h
//  matrixCalculator
//
//  Created by Vikrant More on 20/01/16.
//  Copyright © 2016 Vikrant More. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorClass.h"

@interface ViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *m1_01;
@property (weak, nonatomic) IBOutlet UITextField *m1_00;
@property (weak, nonatomic) IBOutlet UITextField *m1_02;
@property (weak, nonatomic) IBOutlet UITextField *m1_10;
@property (weak, nonatomic) IBOutlet UITextField *m1_11;
@property (weak, nonatomic) IBOutlet UITextField *m1_12;
@property (weak, nonatomic) IBOutlet UITextField *m1_20;
@property (weak, nonatomic) IBOutlet UITextField *m1_21;
@property (weak, nonatomic) IBOutlet UITextField *m1_22;

@property (weak, nonatomic) IBOutlet UITextField *m2_00;
@property (weak, nonatomic) IBOutlet UITextField *m2_01;
@property (weak, nonatomic) IBOutlet UITextField *m2_02;
@property (weak, nonatomic) IBOutlet UITextField *m2_10;
@property (weak, nonatomic) IBOutlet UITextField *m2_11;
@property (weak, nonatomic) IBOutlet UITextField *m2_12;
@property (weak, nonatomic) IBOutlet UITextField *m2_20;
@property (weak, nonatomic) IBOutlet UITextField *m2_21;
@property (weak, nonatomic) IBOutlet UITextField *m2_22;

@property (weak, nonatomic) IBOutlet UILabel *r_00;
@property (weak, nonatomic) IBOutlet UILabel *r_01;
@property (weak, nonatomic) IBOutlet UILabel *r_02;
@property (weak, nonatomic) IBOutlet UILabel *r_10;
@property (weak, nonatomic) IBOutlet UILabel *r_11;
@property (weak, nonatomic) IBOutlet UILabel *r_12;
@property (weak, nonatomic) IBOutlet UILabel *r_20;
@property (weak, nonatomic) IBOutlet UILabel *r_21;
@property (weak, nonatomic) IBOutlet UILabel *r_22;

@property (weak, nonatomic) IBOutlet UILabel *ti;
@property (weak, nonatomic) IBOutlet UILabel *operation;
@property (weak, nonatomic) IBOutlet UILabel *Amat;
@property (weak, nonatomic) IBOutlet UILabel *Bmat;
@property (weak, nonatomic) IBOutlet UILabel *Dmat;

@property (weak, nonatomic) IBOutlet UILabel *Cmat;
@property (nonatomic) CalculatorClass *myCalculator;





- (IBAction)addMatrix:(id)sender;
- (IBAction)subtractMatrix:(id)sender;
- (IBAction)multiplyMatrix:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)invertMatrix:(id)sender;
- (IBAction)elementDivideMatrix:(id)sender;
- (IBAction)elementMultiplyMatrix:(id)sender;
- (IBAction)determinantMatrix:(id)sender;
- (IBAction)dotProductMatrix:(id)sender;
- (IBAction)crossProductMatrix:(id)sender;
- (IBAction)threeCrossOneMultiplyMatrix:(id)sender;
- (IBAction)randomizeAMatrix:(id)sender;
- (IBAction)randomizeBMatrix:(id)sender;



@end

