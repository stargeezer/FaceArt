//
//  FAViewController.h
//  FaceArt
//
//  Created by Mark Strand on 8/24/12.
//  Copyright (c) 2012 Panoramas Northwest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/Quartzcore.h>
#import <CoreImage/CoreImage.h>
#import <CoreMedia/CoreMedia.h>



@interface FAViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    IBOutlet UIView *previewView;
    
    AVCaptureVideoPreviewLayer* previewLayer;
    AVCaptureVideoDataOutput* videoDataOutput;
    AVCaptureSession* lclSession;
    
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureStillImageOutput *stillImageOutput;
    
    CIDetector *faceDetector;
   // BOOL detectFaces;
    
    BOOL isUsingFrontFacingCamera;
    
    CALayer* featuresLayer;
    
    // facePoints
    CGPoint lEyePoint;
    CGPoint rEyePoint;
    CGPoint mouthPoint;
    
}

@property (nonatomic, retain)AVCaptureSession *lclSession;

@end