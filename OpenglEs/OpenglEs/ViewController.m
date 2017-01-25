//
//  ViewController.m
//  OpenglEs
//
//  Created by xx on 13-5-4.
//  Copyright (c) 2013年 xx. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit/JSONKit.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    self.MyDragView.delegate=self.OPenglESView;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
   // [self drawFrame];    
    [NSThread detachNewThreadSelector:@selector(TimedTakePicture) toTarget:self withObject:nil];   
}

-(void)TimedTakePicture
{
    NSAutoreleasePool*pool =[[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop =[NSRunLoop currentRunLoop];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [runLoop run];
    [pool release];
}

-(void)timerFired
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_OPenglESView release];
    [_MyDragView release];
    [super dealloc];
}
@end
