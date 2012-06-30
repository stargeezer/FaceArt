//
//  FAScene.h
//  FaceArt
//
//  Created by Mark Strand on 6/30/12.
//  Copyright (c) 2012 Panoramas Northwest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FAScene : NSObject
{
    GLKVector4 clearColor;
}

@property GLKVector4 clearColor;

-(void) update;
-(void) render;

@end
