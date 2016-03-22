//
//  ViewController.m
//  HorizonLine
//
//  Created by Vikrant More on 19/02/16.
//  Copyright © 2016 Vikrant More. All rights reserved.
//



#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - View methods
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Create and initialize a tap gesture
    //    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
    //                                             initWithTarget:self action:@selector(detectTap:)];
    //
    //    // Specify that the gesture must be a single tap
    //    tapRecognizer.numberOfTapsRequired = 1;
    //    [self.view addGestureRecognizer:tapRecognizer];
    //
    //    NSLog(@"PI constant: %f",M_PI);
    UIApplication *thisApp = [UIApplication sharedApplication];
    thisApp.idleTimerDisabled = YES;
    //Initialize any variables
    _viewSize.x = self.view.frame.size.width;//Width of UIView
    _viewSize.y =self.view.frame.size.height;//Height of UIView
    _listOfCircles = [[NSMutableArray alloc]init];
    //Initialize AVCaptureDevice
    [self initCapture];
    self.view.multipleTouchEnabled = YES;
    _smallAngleTracking = NO;
    
    [[self.startButton layer] setCornerRadius:8.0f];
    [[self.startButton layer] setBorderWidth:1.0f];
    [self.startButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    
    [[self.stopButton layer] setCornerRadius:8.0f];
    [[self.stopButton layer] setBorderWidth:1.0f];
    [self.stopButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    
    _time_prev_gyro = 0;
    _timeZeroGyro = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - Camera
- (void)initCapture {
    
    AVCaptureDevice     *theDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:theDevice
                                          error:nil];
    /*We setupt the output*/
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    /*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
     If you don't want this behaviour set the property to NO */
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    //We create a serial queue to handle the processing of our frames
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    // Set the video output to store frame in YpCbCr planar so we can access the brightness in contiguous memory
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    // choice is kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange or RGBA
    
    NSNumber* value = [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] ;
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    //And we create a capture session
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //You can change this for different resolutions
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    
    //We add input and output
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    //Initialize and add imageview
    self.imageView = [[UIImageView alloc] init];
    
#warning Initialize to size of the screen. You need to select the right values and replace 100 and 100
    //TODO: select right width and height value
    self.imageView.frame = CGRectMake(0, 0,320.0,568.0);
    
    //Add subviews to master view
    //The order is important in order to view the button
    [self.view addSubview:self.imageView];
    
#warning Add any UI elements here
    //Once startRunning is called the camera will start capturing frames
    [self.captureSession startRunning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    _circleCenter = [touch locationInView:self.view];
    _circleCenter.x = _circleCenter.x*(_contextSize.y/_viewSize.x);
    _circleCenter.y = _circleCenter.y*(_contextSize.x/_viewSize.y);
    _objectToDraw = CIRCLE;
    //NSLog(@"inital %f, %f", _circleCenter.x, _circleCenter.y);
    Circle* circle = [[Circle alloc]initWithCGPoint:_circleCenter];
    //Add it to list of circles
    [_listOfCircles addObject:circle];
    
    
    _circleCenter.y = (_contextSize.x) - (_circleCenter.y);
    if (_motionSelectControl.selectedSegmentIndex == GYRO) {
        _startGyroTracking = YES;
        _initializeGyroTracking = YES;
    }
    else if (_motionSelectControl.selectedSegmentIndex == DEVICE){
        _startDMTracking = YES;
        _initializeTracking_DM = YES;
    }
    
}


- (IBAction)motionSelectChanged:(id)sender {
    
    if(_motionSelectControl.selectedSegmentIndex == GYRO){
        //Stop gyro data
        if (_gManager) {
            [_gManager stopGyroUpdates];
        }
        
        //If deviceMotion is selected and start button is not pressed, check for data. If not available, then start it.
        if (!_mManager.isGyroAvailable) {
            
            _mManager = [[CMMotionManager alloc] init];
            _mManager.deviceMotionUpdateInterval = 1.0/10.0;
            
            //Initialize queue
            _gyroQueue = [NSOperationQueue currentQueue];
            
            //Used to determine time reference
            _firstTime = true;
            
            _mManager = [[CMMotionManager alloc] init];
            
            //Used to determine time reference
            _firstTime = true;
            
        }
        //Start DeviceMotion updates using referenc frame: CMAttitudeReferenceFrameXArbitraryZVertical, Queue: accelerometerQueue
        [_mManager  startGyroUpdatesToQueue:_gyroQueue withHandler:^(CMGyroData *motion, NSError *error){
            if (_startGyroTracking) {
                if (_initializeGyroTracking) {
                    if(_timeZeroGyro){
                        _rotationMatrix = GLKMatrix3Identity;
                        _timeZeroGyro = NO;
                        _time_prev_gyro = motion.timestamp;
                    }
                    else{
                        // NSLog(@"doing something");
                        GLKVector3 gyro = GLKVector3Make(motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z);
                        NSTimeInterval time_curr = motion.timestamp;
                        NSTimeInterval deltaTime = time_curr - _time_prev_gyro;
                        GLKVector3 deltaRotation = GLKVector3MultiplyScalar(gyro, deltaTime);
                        
                        Rodriguez* rodriguez = [[Rodriguez alloc] init];
                        GLKMatrix3 rotation;
                        if(_smallAngleTracking == NO)
                            rotation = [rodriguez fullRodriguez:deltaRotation];
                        else{
                            rotation = [rodriguez smallAngleRodriguez:deltaRotation];
                            NSLog(@"small");
                        }
                        
                        _rotationMatrix = GLKMatrix3Multiply(_rotationMatrix, rotation);
                        
                        GLKVector3 cameraCoords = [rodriguez pixelCoordsToCamera:_circleCenter];
                        GLKVector3 rotatedPointCameraCoords = GLKMatrix3MultiplyVector3(_rotationMatrix,cameraCoords);
                        rotatedPointCameraCoords.x = -rotatedPointCameraCoords.x;
                        rotatedPointCameraCoords.z = -rotatedPointCameraCoords.z;
                        CGPoint pixelCoords = [rodriguez cameraCoordsToPixel:rotatedPointCameraCoords];
                        
                        Circle* circle = [[Circle alloc]initWithCGPoint:pixelCoords];
                        if(!_trackOrTraceFlag)
                            [_listOfCircles removeAllObjects];
                        [_listOfCircles addObject:circle];
                        _time_prev_gyro = time_curr;
                        
                        _objectToDraw = CIRCLE;
                    }
                }
            }
        }];
        
    }
    else if(_motionSelectControl.selectedSegmentIndex == DEVICE){
        
        if (_mManager) {
            [_gyroQueue setSuspended:TRUE];
            [_gyroQueue cancelAllOperations];
            
            //stop device motion updates
            [_mManager stopGyroUpdates];
        }
        
        [_gManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:_accelerometerQueue withHandler:^(CMDeviceMotion *motion, NSError *error){
            if(_startDMTracking){
                if(_initializeTracking_DM){
                    _initialRotationMatrix = motion.attitude;
                    _initializeTracking_DM = NO;
                }
                else{
                    
                    CMAttitude* att = motion.attitude;
                    
                    [att multiplyByInverseOfAttitude:_initialRotationMatrix];
                    Rodriguez* rodriguez = [[Rodriguez alloc] init];
                    GLKVector3 cameraCoords = [rodriguez pixelCoordsToCamera:_circleCenter];
                    
                    GLKMatrix3 rot = GLKMatrix3Make(att.rotationMatrix.m11, att.rotationMatrix.m12, att.rotationMatrix.m13,
                                                    att.rotationMatrix.m21, att.rotationMatrix.m22, att.rotationMatrix.m23,
                                                    att.rotationMatrix.m31, att.rotationMatrix.m32, att.rotationMatrix.m33);
                    
                    GLKVector3 rotatedPointCameraCoords = GLKMatrix3MultiplyVector3(rot,cameraCoords);
                    rotatedPointCameraCoords.x = -rotatedPointCameraCoords.x;
                    rotatedPointCameraCoords.z = -rotatedPointCameraCoords.z;
                    
                    CGPoint pixelCoords = [rodriguez cameraCoordsToPixel:rotatedPointCameraCoords];
                    
                    Circle* circle = [[Circle alloc]initWithCGPoint:pixelCoords];
                    if(!_trackOrTraceFlag)
                        [_listOfCircles removeAllObjects];
                    [_listOfCircles addObject:circle];
                    
                    _objectToDraw = CIRCLE;
                }
            }
        }];
    }
}

- (IBAction)startSensing:(id)sender {
    
    _mManager = [[CMMotionManager alloc] init];
    _gManager = [[CMMotionManager alloc] init];
    
    //Initialize queue
    _gyroQueue = [NSOperationQueue currentQueue];
    _accelerometerQueue = [NSOperationQueue currentQueue];
    _gManager.accelerometerUpdateInterval = 1.0/10.0;
    
    //Used to determine time reference
    _firstTime = true;
    _mManager.gyroUpdateInterval = 1.0/10.0;
    
    //Used to determine time reference
    _firstTime = true;
    [_mManager startGyroUpdates];
    _timeZeroGyro = YES;
    
}

- (IBAction)stopSensing:(id)sender {
    [_gyroQueue setSuspended:TRUE];
    [_gyroQueue cancelAllOperations];
    
    //stop gyro updates
    [_mManager stopDeviceMotionUpdates];
    [_mManager stopGyroUpdates];
    
    [_accelerometerQueue setSuspended:TRUE];
    [_accelerometerQueue cancelAllOperations];
    
    //stop device motion updates
    [_gManager stopDeviceMotionUpdates];
    [_gManager stopGyroUpdates];
    
    //Reset timestamp flag
    _firstTime = true;
    
    _motionSelectControl.selectedSegmentIndex= DESELECT;
    _initializeGyroTracking = NO;
    _initializeTracking_DM = NO;
    _startDMTracking = NO;
    _startGyroTracking = NO;
    _smallAngleTracking = NO;
    [_listOfCircles removeAllObjects];
    _timeZeroGyro = NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    self.width = CVPixelBufferGetWidth(imageBuffer);
    self.height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, self.width, self.height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //Context size
    _contextSize.x = self.width;
    _contextSize.y = self.height;
    
    
#warning Here is where you draw 2D objects
    
    
    if (_objectToDraw == CIRCLE) {
        
        //Iterate through the list of circles and draw them all
        for (int i=0; i<[_listOfCircles count]; i++) {
            
            //Mapping constant calculated to do the mapping from Points to Context
            //[_listOfCircles[i] drawCircle:context:CGPointMake((_contextSize.y/_viewSize.x), (_contextSize.x/_viewSize.y))];
            [_listOfCircles[i] drawCircle:context:CGPointMake(1, 1)];
        }
    }
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:(CGFloat)1 orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    //notice we use this selector to call our setter method 'setImg' Since only the main thread can update this
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}




- (IBAction)smallAngleChanged:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if([mySwitch isOn])
        _smallAngleTracking = YES;
    else
        _smallAngleTracking = NO;
    
}

- (IBAction)trackTraceChanged:(id)sender {
    UISwitch *track = (UISwitch *)sender;
    if([track isOn])
        _trackOrTraceFlag = YES;
    else
        _trackOrTraceFlag = NO;
    
}

@end
