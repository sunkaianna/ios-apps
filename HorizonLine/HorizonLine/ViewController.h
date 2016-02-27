//
//  ViewController.h
//  HorizonLine
//
//  Created by Vikrant More on 19/02/16.
//  Copyright © 2016 Vikrant More. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#include <math.h>
#include "Line.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>


@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>


//Enums
typedef enum { LINE,
               CIRCLE,
               SQUARE } ObjectType;

typedef enum { DESELECT = -1,
               DEVICE,
               ACCEL
             } infoType;

//Properties
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) size_t height;
@property (nonatomic) size_t width;
@property (nonatomic) CGPoint contextSize;
@property (nonatomic) CGPoint viewSize;
@property (nonatomic) ObjectType objectToDraw;


@property (weak, nonatomic) IBOutlet UIStepper *translateScaling;
@property (strong, nonatomic) CMMotionManager *mManager;
@property (nonatomic) BOOL firstTime;
@property (nonatomic) NSOperationQueue *accelerometerQueue;
@property (nonatomic) NSTimeInterval startSimulationTime;
@property (nonatomic) GLKMatrix3 rotationMatrix;
@property (nonatomic) GLKVector3 transformedDeviceMotion;
@property (nonatomic) GLKVector3 transformedAccel;
@property (nonatomic) double focalLength;
@property (nonatomic) Line* interceptsDeviceMotion;
@property (nonatomic) Line* interceptsAccel;
@property (nonatomic) BOOL drawAccelLine;

//Outlets

@property (weak, nonatomic) IBOutlet UILabel *xCMDeviceMotionAccelerometer;
@property (weak, nonatomic) IBOutlet UILabel *yCMDeviceMotionAccelerometer;
@property (weak, nonatomic) IBOutlet UILabel *zCMDeviceMotionAccelerometer;

@property (weak, nonatomic) IBOutlet UILabel *xGravity;
@property (weak, nonatomic) IBOutlet UILabel *yGravity;
@property (weak, nonatomic) IBOutlet UILabel *zGravity;

@property (weak, nonatomic) IBOutlet UILabel *combinedDeviceMotion;
@property (weak, nonatomic) IBOutlet UILabel *accel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *motionSelectControl;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *saveImage;

//Actions

- (IBAction)motionSelectChanged:(id)sender;
- (IBAction)startSensing:(id)sender;
- (IBAction)stopSensing:(id)sender;
- (IBAction)saveImage:(id)sender;

@end

