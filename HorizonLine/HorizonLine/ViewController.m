//
//  ViewController.h
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
   
    //Initialize AVCaptureDevice
    [self initCapture];
    self.view.multipleTouchEnabled = YES;
    
    //Common R Matrix for device motion and accel data
    _rotationMatrix = GLKMatrix3Make(1, 0, 0,
                                     0, -1, 0,
                                     0, 0, -1);
    _focalLength = (25*640)/28;
    
    [[self.startButton layer] setCornerRadius:8.0f];
    [[self.startButton layer] setBorderWidth:1.0f];
    [self.startButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    
    [[self.stopButton layer] setCornerRadius:8.0f];
    [[self.stopButton layer] setBorderWidth:1.0f];
    [self.stopButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];

    [[self.saveImage layer] setCornerRadius:8.0f];
    [[self.saveImage layer] setBorderWidth:1.0f];
    [self.saveImage.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];

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

- (IBAction)motionSelectChanged:(id)sender {
    
    if(_motionSelectControl.selectedSegmentIndex == DEVICE){
        //Stop accel data
        if (_mManager) {
            [_mManager stopAccelerometerUpdates];
        }
        
        //If deviceMotion is selected and start button is not pressed, check for data. If not available, then start it.
        if (!_mManager.isAccelerometerAvailable) {
            
            _mManager = [[CMMotionManager alloc] init];
            _mManager.deviceMotionUpdateInterval = 1.0/10.0;
            
            //Initialize queue
            _accelerometerQueue = [NSOperationQueue currentQueue];
            
            //Used to determine time reference
            _firstTime = true;
            
            _mManager = [[CMMotionManager alloc] init];
        
            //Used to determine time reference
            _firstTime = true;

        }
            //Start DeviceMotion updates using referenc frame: CMAttitudeReferenceFrameXArbitraryZVertical, Queue: accelerometerQueue
            [_mManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:_accelerometerQueue withHandler:^(CMDeviceMotion *motion, NSError *error){
                
                //Get a timestamp of the events, starting at 0s
                if (_firstTime) {
                    _startSimulationTime = motion.timestamp;
                    _firstTime = false;
                } else {
                    CFAbsoluteTime currentSimulationTime = motion.timestamp-_startSimulationTime;
                    // NSLog(@"Current time: %f", currentSimulationTime);
                }
                GLKVector3 gravity =GLKVector3Make(motion.gravity.x,
                                                   motion.gravity.y,
                                                   motion.gravity.z);
               
                _transformedDeviceMotion = GLKMatrix3MultiplyVector3(_rotationMatrix, gravity);
                
                _objectToDraw = LINE;
                
                double C = -_transformedDeviceMotion.x*320 - _transformedDeviceMotion.y*240 +_transformedDeviceMotion.z*_focalLength;
                double B = _transformedDeviceMotion.y;
                double A = _transformedDeviceMotion.x;
               
                CGPoint xIntercept = CGPointMake(480,(-C - A*480)/B);
                CGPoint yIntercept = CGPointMake(0, -C/B);
                             //
                if (!isnan(xIntercept.x) || !isnan(xIntercept.y) || !isnan(yIntercept.x) || !isnan(yIntercept.y))
                _interceptsDeviceMotion = [[Line alloc]initWithCGPoint:yIntercept pointTwo:xIntercept];
            }];
        
    }
    else if(_motionSelectControl.selectedSegmentIndex == ACCEL){
        if (_mManager) {
            [_mManager startAccelerometerUpdates];
            _drawAccelLine = YES;
            
            //Stop DeviceMotion
            
            [_accelerometerQueue setSuspended:TRUE];
            [_accelerometerQueue cancelAllOperations];
            
            //stop device motion updates
            [_mManager stopDeviceMotionUpdates];
            
            //Reset timestamp flag
            _firstTime = true;
        }
    }
}

- (IBAction)startSensing:(id)sender {
    
        _mManager = [[CMMotionManager alloc] init];
        _mManager.deviceMotionUpdateInterval = 1.0/10.0;
        
        //Initialize queue
        _accelerometerQueue = [NSOperationQueue currentQueue];
    
        //Used to determine time reference
        _firstTime = true;
    
        _mManager = [[CMMotionManager alloc] init];
        _mManager.accelerometerUpdateInterval = 1.0/10.0;

    //Used to determine time reference
            _firstTime = true;
            [_mManager startAccelerometerUpdates];
   
}

- (IBAction)stopSensing:(id)sender {
    [_accelerometerQueue setSuspended:TRUE];
    [_accelerometerQueue cancelAllOperations];
    
    //stop device motion updates
    [_mManager stopDeviceMotionUpdates];
    [_mManager stopAccelerometerUpdates];
    
    //Reset timestamp flag
    _firstTime = true;
    
    _motionSelectControl.selectedSegmentIndex= DESELECT;

    _interceptsDeviceMotion = [[Line alloc]initWithCGPoint:CGPointMake(0, 0) pointTwo:CGPointMake(0, 0)];
    _interceptsAccel = [[Line alloc]initWithCGPoint:CGPointMake(0, 0) pointTwo:CGPointMake(0, 0)];
    
}

- (IBAction)saveImage:(id)sender {
    // create graphics context with screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    UIImageWriteToSavedPhotosAlbum(screengrab, nil, nil, nil);
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
  
    
    
    
    if (_objectToDraw == LINE){
        if (_motionSelectControl.selectedSegmentIndex == DEVICE) {
            [_interceptsDeviceMotion drawLine:context:CGPointMake(1, 1)];
        }
        else if (_motionSelectControl.selectedSegmentIndex == ACCEL){
            [_interceptsAccel drawLine:context :CGPointMake(1, 1)];
        }
    }
    
    if (_drawAccelLine) {
        GLKVector3 accel = GLKVector3Make(_mManager.accelerometerData.acceleration.x,
                                          _mManager.accelerometerData.acceleration.y,
                                          _mManager.accelerometerData.acceleration.z);
        
        _transformedAccel = GLKMatrix3MultiplyVector3(_rotationMatrix, accel);
        
        double C = -_transformedAccel.x*320 - _transformedAccel.y*240 +_transformedAccel.z*_focalLength;
        double B = _transformedAccel.y;
        double A = _transformedAccel.x;
        
        CGPoint xIntercept = CGPointMake(480,(-C - A*480)/B);
        CGPoint yIntercept = CGPointMake(0, -C/B);
        
        _objectToDraw = LINE;
        
        if (!isnan(xIntercept.x) || !isnan(xIntercept.y) || !isnan(yIntercept.x) || !isnan(yIntercept.y))
            _interceptsAccel = [[Line alloc]initWithCGPoint:yIntercept pointTwo:xIntercept];
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



@end
