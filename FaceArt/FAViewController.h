//
//  FAViewController.h
//  FaceArt
//
//  Created by Mark Strand on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

#import "constants.h"


@interface FAViewController : GLKViewController
{
    
    float _curRed;
    float _aspect;
    BOOL _increasing;
    float _rotation;
    
    float _touchX;
    float _touchY;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    GLKTextureInfo *texture;
}

@property(strong, nonatomic)EAGLContext *context;
@property(strong, nonatomic) GLKBaseEffect *_effect;
@property(readwrite)NSMutableArray *vertices;
@property(strong, nonatomic)GLKTextureInfo *texture;

-(GLuint)createShader:(GLenum)type source:(const char*)source;


@end
