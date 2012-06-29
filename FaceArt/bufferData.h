//
//  bufferData.h
//  FaceArt
//
//  Created by Mark Strand on 6/28/12.
//  Copyright (c) 2012 Panoramas Northwest. All rights reserved.
//

#ifndef FaceArt_bufferData_h
#define FaceArt_bufferData_h

typedef struct 
{
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = 
{
    {{1, -1,0}, {1,0,0,1}},
    {{1,1,0}, {0,1,0,1}},
    {{-1,1,0}, {0,0,1,1}},
    {{-1,-1,0}, {0,0,0,1}},
    {{2,2,0},{1,0,0,1 }},
    {{2,3,0},{0,1,0,1}},
    {{3,3,0},{0,0,1,1}}
};

const GLubyte Indices[] = 
{
    0,1,2,
    2,3,0,
    4,5,6
    
};



#endif
