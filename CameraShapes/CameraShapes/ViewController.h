//
//  ViewController.h
//  Assignment2Template
//
//  Created on 2/1/16.
//  Copyright © 2016 CMPE161. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#include <math.h>
#include "Circle.h"
#include "Line.h"
#include "Square.h"

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

//Enums
typedef enum { LINE, CIRCLE, SQUARE } ObjectType;

//Properties
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) size_t height;
@property (nonatomic) size_t width;
@property (nonatomic) CGPoint contextSize;
@property (nonatomic) CGPoint viewSize;
@property (nonatomic) ObjectType objectToDraw;
@property (nonatomic) double angle;
@property (nonatomic) BOOL buttonState;
@property (nonatomic) int translateIncrement;
@property (nonatomic) NSMutableArray* listOfCircles;
@property (nonatomic) NSMutableArray* listOfLines;

@property (weak, nonatomic) IBOutlet UIStepper *translateScaling;



//Outlets
@property (weak, nonatomic) IBOutlet UISegmentedControl *object2DSelectionSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *objectRotatedValue;

@property (weak, nonatomic) IBOutlet UISwitch *rotateOrTranslateButton;

@property (weak, nonatomic) IBOutlet UIStepper *translateIncrementValue;



//Actions
- (IBAction)object2DSelectionSegmentChanged:(id)sender;

- (IBAction)objectRotatedAction:(id)sender;
- (IBAction)rotateOrTranslateControl:(id)sender;
- (IBAction)translateScalingController:(id)sender;




@end

