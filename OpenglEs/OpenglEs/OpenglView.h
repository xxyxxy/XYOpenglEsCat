//
//  OpenglView.h
//  OpenglEs
//
//  Created by xx on 13-5-4.
//  Copyright (c) 2013年 xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <ImageIO/ImageIO.h>
#import "DragView.h"
@interface OpenglView : UIView<DragViewDelegate>
{
    GLvoid *DataPtr;
    GLfloat spriteVertices[9];//计算后的顶点坐标
    GLuint spriteTexture;
    EAGLContext *context;
    GLuint defaultFramebuffer, colorRenderbuffer;

    GLuint viewRenderbuffer, viewFramebuffer;
    
}
@property (nonatomic, retain) EAGLContext *context;

@end
