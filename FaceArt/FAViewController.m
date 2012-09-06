//
//  FAViewController.m
//  FaceArt
//
//  Created by Mark Strand on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FAViewController.h"


void *AVCaptureStillImageIsCapturingStillImageContext = (void*)"AVCaptureStillImageIsCapturingStillImageContext";

@implementation FAViewController
@synthesize lclSession;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAVCapture];
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
	faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    // then add the CALayer to the view, like this:
    featuresLayer = [CALayer new];
    featuresLayer.delegate = self;
    featuresLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:featuresLayer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark camera stuff

- (void)setupAVCapture
{
	NSError *error = nil;
	
	AVCaptureSession *session = [AVCaptureSession new];
    [session setSessionPreset:AVCaptureSessionPreset640x480];
	
    // Select a video device, make an input
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	
    isUsingFrontFacingCamera = NO;
	if ( [session canAddInput:deviceInput] )
		[session addInput:deviceInput];
	
    // Make a still image output
	stillImageOutput = [AVCaptureStillImageOutput new];
	[stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:AVCaptureStillImageIsCapturingStillImageContext];
    
	if ( [session canAddOutput:stillImageOutput] )
		[session addOutput:stillImageOutput];
	
    // Make a video data output
	videoDataOutput = [AVCaptureVideoDataOutput new];
	
    // set the video output 
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
	[videoDataOutput setVideoSettings:rgbOutputSettings];
    
    // tell the data output queue to drop frames if it is blocked (as we process the still image)
	[videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; 
    
    // create a serial dispatch queue 
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
	[videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
	
    if ([session canAddOutput:videoDataOutput])
		[session addOutput:videoDataOutput];
	[[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
	
	previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	[previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
	[previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	CALayer *rootLayer = [previewView layer];
	[rootLayer setMasksToBounds:YES];
    
	[previewLayer setFrame:[rootLayer bounds]];
	[rootLayer addSublayer:previewLayer];
	[session startRunning];
    self.lclSession = session;
    
    [self switchCameras];
}

// switch front/back camera
- (void)switchCameras
{
	AVCaptureDevicePosition desiredPosition;
	if (isUsingFrontFacingCamera)
		desiredPosition = AVCaptureDevicePositionBack;
	else
		desiredPosition = AVCaptureDevicePositionFront;
	
	for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) 
    {
		if ([d position] == desiredPosition) 
        {
			[[previewLayer session] beginConfiguration];
			AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
			for (AVCaptureInput *oldInput in [[previewLayer session] inputs]) 
            {
				[[previewLayer session] removeInput:oldInput];
			}
			[[previewLayer session] addInput:input];
			[[previewLayer session] commitConfiguration];
			break;
		}
	}
	isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{	
	// got an image
	CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
	CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
	
	NSDictionary *imageOptions = nil;

    imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:6] forKey:CIDetectorImageOrientation];
	NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self findFeaturePoints:features];
    });    
}

// this function 'normalizes' the coordinates from the video camera
// to the CALayer
-(CGPoint)normalizePoint:(CGPoint)pt
{
    CGPoint retPt;
    retPt.x = (480 - pt.y)  / 1.5;
    retPt.y = pt.x / 1.5;
    return retPt;
}

// identify and find the feature points so we can draw them
- (void)findFeaturePoints:(NSArray *)features 
{
    boolean_t needsDisplay;
	for (CIFaceFeature *ff in features) 
    {
        needsDisplay = false;
        
        if (ff.hasLeftEyePosition) 
        {
            lEyePoint = [self normalizePoint:ff.leftEyePosition];
            NSLog(@"lefteye x: %f y: %f",ff.leftEyePosition.x,ff.leftEyePosition.y);
            needsDisplay = true;
        }
        if (ff.hasRightEyePosition) 
        {
            rEyePoint = [self normalizePoint:ff.rightEyePosition];
            needsDisplay = true;
        }
        if (ff.hasMouthPosition) 
        {
            mouthPoint = [self normalizePoint:ff.mouthPosition]; 
            needsDisplay = true;
        }
        if (needsDisplay) 
        {
            [featuresLayer setNeedsDisplay];
        }
    }
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    float featureSize = 30.0;
    
    CGContextSetLineWidth(ctx,28.0);
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 0.6);    
    CGContextAddEllipseInRect(ctx, CGRectMake(lEyePoint.x, lEyePoint.y, featureSize, featureSize));
    CGContextStrokePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 0.0, 1.0, 0.0, 0.6);
    CGContextAddEllipseInRect(ctx, CGRectMake(rEyePoint.x, rEyePoint.y, featureSize, featureSize));
    CGContextStrokePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 1.0, 0.6);
    CGContextAddEllipseInRect(ctx, CGRectMake(mouthPoint.x, mouthPoint.y, featureSize, featureSize));
    
    CGContextStrokePath(ctx);
}

@end
