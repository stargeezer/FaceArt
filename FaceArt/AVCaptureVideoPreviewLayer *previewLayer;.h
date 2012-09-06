//
//  FAViewController.h
//  FaceArt
//
//  Created by Mark Strand on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

#import "constants.h"


@interface FAViewController : UIViewController
{
    
    BOOL isUsingFrontFacingCamera;
    
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoDataOutput *videoDataOutput;
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureSession *lclSession;
           
}

@end
