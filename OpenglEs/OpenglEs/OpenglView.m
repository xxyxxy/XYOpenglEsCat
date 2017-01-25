//
//  OpenglView.m
//  OpenglEs
//
//  Created by xx on 13-5-4.
//  Copyright (c) 2013年 xx. All rights reserved.
//

#import "OpenglView.h"
#import <QuartzCore/QuartzCore.h>
@implementation OpenglView
@synthesize context;


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:.
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
	if (self)
    {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = NO;
        eaglLayer.backgroundColor=[UIColor clearColor].CGColor;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }   
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

const GLfloat spriteTexcoords[] = {//纹理坐标
    0, 1,
    0, 0,
    1, 0,
    1, 1,
};

//纹理映射在窗口中的对应的顶点，每两个点分别对应左上角，左下角，右下角，右上角
- (void)InitializationSpriteVertices;
{
    spriteVertices[0]=-0.6;
    spriteVertices[1]=0.6;
    spriteVertices[2]=-0.6;
    spriteVertices[3]=-0.6;
    spriteVertices[4]=0.6;
    spriteVertices[5]=-0.6;
    spriteVertices[6]=0.6;
    spriteVertices[7]=0.8;
    glGenTextures(1, &spriteTexture);//生成纹理
}

//DragView delegate 拖动右上角小方块 变换图形
-(void)DragTopRightViewWithRangeOfX:(float)ARangeOfX Y:(float)ARangeOfY
{
    if (spriteVertices[6]+spriteVertices[6]*ARangeOfX!=0) {
    spriteVertices[6]=spriteVertices[6]+spriteVertices[6]*ARangeOfX;
    }
    if (spriteVertices[7]+spriteVertices[7]*ARangeOfY!=0) {
    spriteVertices[7]=spriteVertices[7]+spriteVertices[7]*ARangeOfY;
    }
    [self setNeedsLayout];
}

//实现纹理贴图
- (void)drawImage:(UIImage *)image
{
    GLvoid *ADataPtr ;
    ADataPtr = (GLubyte *) calloc(image.size.width * image.size.height * 4, sizeof(GLubyte));
    DataPtr=ADataPtr;
    NSData * ImageData = UIImageJPEGRepresentation(image, 1.0);
    CGImageRef imageRef;
    CGImageSourceRef imageSource =
    CGImageSourceCreateWithData((CFDataRef)ImageData, NULL);
    imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    CGImageRef      spriteImage = image.CGImage;
    CGContextRef    spriteContext;
    GLsizei         width, height;
    width=image.size.width;
    height=image.size.height;
    // CoreGraphics draw
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(spriteImage);
    spriteContext = CGBitmapContextCreate(DataPtr, width, height,
                                          8, width * 4, colorSpace,
    kCGImageAlphaPremultipliedLast);
    //CGContextSetAllowsAntialiasing(spriteContext, NO);
    //CGContextClearRect(spriteContext, CGRectMake(0, 0, width, height));
    CGContextTranslateCTM(spriteContext, 0.0, height);
    CGContextScaleCTM(spriteContext, 1.0, -1.0);
    //画图
    CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height),spriteImage);
    glPushMatrix();
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, DataPtr);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glPopMatrix();
    glFlush();
    CGImageRelease(imageRef);
    CFRelease(imageSource);
}

- (void)initTexture
{
    //spriteTexture=0;
   // glMatrixMode(GL_PROJECTION);
   // glLoadIdentity();
    glVertexPointer(2, GL_FLOAT, 0, spriteVertices);    // 纹理映射在窗口中的对应的顶点信息
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, spriteTexcoords); // 纹理需要被映射部分的坐标
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBindTexture(GL_TEXTURE_2D, spriteTexture);//绑定纹理
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);//配置参数
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    // Enable use of the texture
    glEnable(GL_TEXTURE_2D);//启用2D纹理
}

//创建framebuffer
- (BOOL)EScreateFramebuffer {
    
    GLint backingWidth=self.frame.size.width;
    GLint backingHeight=self.frame.size.height;
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
	glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    return YES;
}

- (void)layoutSubviews {
    //先清屏
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    if (!viewFramebuffer) {
        [self InitializationSpriteVertices];
        [EAGLContext setCurrentContext:context];
        [self EScreateFramebuffer];
    }
    //绘图
    UIImage *AImage=[UIImage imageNamed:@"Image(1).jpg"];
    [self initTexture];
    [self drawImage:AImage];
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

@end
