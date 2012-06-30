//
//  FAScene.m
//  FaceArt
//
//  Created by Mark Strand on 6/30/12.
//  Copyright (c) 2012 Panoramas Northwest. All rights reserved.
//

#import "FAScene.h"
#import <GLKit/GLKit.h>

@implementation FAScene

@synthesize clearColor;

-(void)update
{
    
}

-(void)render
{
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
    glClear(GL_COLOR_BUFFER_BIT);
}
@end
