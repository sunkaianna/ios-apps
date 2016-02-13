//
//  ViewController.m
//  Assignment2Template
//
//  Created on 2/1/16.
//  Copyright © 2016 CMPE161. All rights reserved.
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
    
    //Initialize any variables
    _viewSize.x = self.view.frame.size.width;//Width of UIView
    _viewSize.y =self.view.frame.size.height;//Height of UIView
    
    //NSLog(@"Width of UIView: %f",_viewSize.x);
    //NSLog(@"Height of UIView: %f",_viewSize.y);
    
    //Initialize arrays
    _listOfCircles = [[NSMutableArray alloc]init];
    _listOfLines = [[NSMutableArray alloc]init];
    
    //Initialize AVCaptureDevice
    [self initCapture];
    self.view.multipleTouchEnabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(UIEventSubtypeMotionShake){
        NSLog(@"Shaking!\n");
        [_listOfCircles removeAllObjects];
        [_listOfLines removeAllObjects];
        
    }
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
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
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
    [self.view addSubview:_object2DSelectionSegmentControl];//Adding the segment control
    [self.view addSubview:_objectRotateSlider];
    
    //Once startRunning is called the camera will start capturing frames
    [self.captureSession startRunning];
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
    
    
    //----------------------------------------------------------------------------------------
     //If you need to do something on the image, uncomment the following
     ///////////////////////////
     // we copy  imageBuffer into another chunk of memory
     // this is necessary otherwise it will slow things down
     // however, we should be able to allocate this buffer once and for all rather than creating it and destroying it at each frame
    //----------------------------------------------------------------------------------------
//    uint8_t *base = (uint8_t *) malloc(bytesPerRow * self.height * sizeof(uint8_t));
//    memcpy(base, baseAddress, bytesPerRow * self.height);
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    
//    NSLog(@"%zu",self.height);
//    NSLog(@"%zu",self.width);
//    NSLog(@"Bytes per row: %zu",bytesPerRow);
//    
//    // just for fun, let's do something on this image
//    // swap color channels
//    uint8_t *tp1, *tp2;
//    tp1 = base;
//    for (int iy=0;iy<self.height; iy++,tp1 += bytesPerRow){
//        tp2 = tp1;
//        for (int ix=0 ;ix<bytesPerRow;ix+=4,tp2+=4){
//            uint8_t aux = *tp2;
//            
//            //NSLog(@"%d",*tp1);
//            
//            if (ix==1500) {
//                *tp2 = 0;
//                *(tp2+1)=0;
//                *(tp2+2) = 0;
//            } else {
//                
//                *tp2 = *(tp2+1);
//                *(tp2+1)=*(tp2+2);
//                *(tp2+2) = aux;
//            }
//            
//        }
//    }
//    
//    //Draw an image
//    
//    // copy the buffer back to imageBuffer
//    CVPixelBufferLockBaseAddress(imageBuffer,0);
//    memcpy(baseAddress, base, bytesPerRow * self.height);
//    free(base);
    //----------------------------------------------------------------------------------------
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, self.width, self.height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    //Context size
    _contextSize.x = self.width;
    _contextSize.y = self.height;
    
    //See the values of the image buffer
//    NSLog(@"Self width: %zu",self.width);
//    NSLog(@"Self height: %zu",self.height);
    
    
#warning Here is where you draw 2D objects
    //----------------------------------------------------------------------------------------
    //TODO: Here is where you draw 2D objects.
    //----------------------------------------------------------------------------------------
    //Draw axes
    

    
    
    
    //Draw circles
    if (_objectToDraw == CIRCLE) {
  
        //Iterate through the list of circles and draw them all
        for (int i=0; i<[_listOfCircles count]; i++) {
            
            //Mapping constant calculated to do the mapping from Points to Context
            [_listOfCircles[i] drawCircle:context:CGPointMake((_contextSize.y/_viewSize.x), (_contextSize.x/_viewSize.y))];
        }
        
    //Draw lines
    }else if (_objectToDraw == LINE){
        //Iterate through the list of circles and draw them all
        for (int i=0; i<[_listOfLines count]; i++) {
            
            //Mapping constant calculated to do the mapping from Points to Context
            [_listOfLines[i] drawLine:context:CGPointMake((_contextSize.y/_viewSize.x), (_contextSize.x/_viewSize.y))];
        }
        
        
        //Example of calling class method from Shape2D to rotate a vector by 90 degrees
//        CGPoint results;
//        results = [Shape2D rotateVector:GLKVector3Make(4.0f, 3.0f, 0.0f) :90];
//        
        
        
        
      

    }else if (_objectToDraw == SQUARE){
        CGPoint center;
        center.x = 160;
        center.y = 284;
        //self.view addSubview:<#(nonnull UIView *)#>
        Square* square = [[Square alloc]initWithCGPoint:center];
        [square drawRectangle:context :CGPointMake((_contextSize.y/_viewSize.x), (_contextSize.x/_viewSize.y))];
        
         }
    //----------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------
    
    
    
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    NSArray *twoTouch = [touches allObjects];
    UITouch *touchOne, *touchTwo;
    CGPoint firstTouch, secondTouch;
    if(touches.count ==2){
        touchOne = [twoTouch objectAtIndex:0];
        touchTwo = [twoTouch objectAtIndex:1];
        firstTouch = [touchOne locationInView:self.view];
        secondTouch = [touchTwo locationInView:self.view];
    }
    CGPoint point = [touch locationInView:self.view];
    CGPoint point1 = [touch locationInView:self.view];
    if (_objectToDraw == CIRCLE){
    Circle* circle = [[Circle alloc]initWithCGPoint:point];
    //Add it to list of circles
        [_listOfCircles addObject:circle];
    }
    if (_objectToDraw == LINE){
        NSLog(@"X1 Location: %f", point.x);
        NSLog(@"Y1 Location: %f", point.y);
        
        NSLog(@"X2 Location: %f", point1.x);
        NSLog(@"Y2 Location: %f", point1.y);
        Line* line = [[Line alloc]initWithCGPoint:firstTouch pointTwo:secondTouch];
        //Circle* circle = [[Circle alloc]initWithCGPoint:point];
        [_listOfLines addObject: line];
    }

    //NSLog(@"X Location: %f", point.x);
    //NSLog(@"Y Location: %f", point.y);
}
//
//- (void)detectTap:(UITapGestureRecognizer *)sender {
//    
//    if(sender.state == UIGestureRecognizerStateEnded){
//        NSLog(@"detected touch");
//        //UITouch *touch = [sender ]
//    }
//}


#pragma mark - Actions
#warning Example of using segmented controls
- (IBAction)object2DSelectionSegmentChanged:(id)sender {
    
    //Line selected
    if (_object2DSelectionSegmentControl.selectedSegmentIndex == LINE) {
        
        //Let the captureOutput() know to draw lines only
        _objectToDraw = LINE;
        
        
        
        
        
    //Circle selected
    }else if (_object2DSelectionSegmentControl.selectedSegmentIndex == CIRCLE) {
        
        //Let the captureOutput() know to draw circles only
        _objectToDraw = CIRCLE;
        
        //Location of the circle on the screen
        //This is different according to your device
        //See: http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
        //CGPoint location, location1;
        
        //Middle of the screen using iPhone6
//        location.x = 188.0f;
//        location.y = 334.0f;
        
        //Middle of the screen using iPhone5S
//        location.x = 160.0f;
//        location.y = 284.0f;
//        
//        location1.x = 188.0f;
//        location1.y = 334.0f;
//        
//        //Create circle object with center location
//        Circle* circle = [[Circle alloc]initWithCGPoint:location];
//        Circle* circle1 = [[Circle alloc]initWithCGPoint:location1];
//        
//        //Add it to list of circles
//        [_listOfCircles addObject:circle];
//        [_listOfCircles addObject:circle1];
    }else if(_object2DSelectionSegmentControl.selectedSegmentIndex == SQUARE){
        _objectToDraw = SQUARE;
        NSLog(@"Hallo");
    }
}
@end
