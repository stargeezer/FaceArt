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
    {{1, -1,0}, {1,0,0,.1}},
    {{1,1,0}, {0,1,0,1}},
    {{-1,1,0}, {0,0,1,1}},
    {{-1,-1,0}, {0,0,0,1}},
    {{4,2,7},{.5,0,0,.4 }},
    {{2,3,0},{0,1,0,1}},
    {{3,3,0},{0,0,1,1}}
};

const Vertex ellipseVertices[] = 
{
    {{1,0,0}, {1,1,0,1}},
    {{-.25, .75,0}, {1,0,0,1}},
    {{-.75, .25, 0}, {1,0,0,1}},
    {{-1, 0,0},{1,0,0,1}},
    {{ -.75,-.25,0},{1,0,0,1}},
    {{ -.25, -.75,0},{1,0,0,1}},
    {{0, -1,0},{1,0,0,1}},
    {{.25, -.75,0},{1,0,0,1}},
    {{.75, -.25,0},{1,0,0,1}},
    {{1.0,0,0},{1,0,0,1}},
    {{.75,.25,0},{1,0,0,1}},
    {{.25,.75,0},{1,0,0,1}}
};

const GLKVector2 textureVertices[] = 
{
    {0,0},
    {1,0},
    {1,1},
    {0,1}
};


const GLubyte Indices[] = 
{
    0,1,2,
    2,3,0,
    4,5,6
    
};


const GLubyte ellipseIndices[] = 
{
    0,1,2,
    3,4,
    5,6,7,
    8,9,10,
    11
};



#endif
