//
//  DragView.m
//  OpenglEs
//
//  Created by xx on 13-5-6.
//  Copyright (c) 2013年 xx. All rights reserved.
//

#import "DragView.h"

@implementation DragView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self.superview];
    LastPoint=point;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self.superview];
        CGRect AOriginalRect=self.frame;
        AOriginalRect.origin.x=AOriginalRect.origin.x+point.x-LastPoint.x;
        AOriginalRect.origin.y=AOriginalRect.origin.y+point.y-LastPoint.y;
  
    if (0<AOriginalRect.origin.x&&AOriginalRect.origin.x<self.superview.frame.size.width) {
        float AXFloat,AYFloat;
        if (0<AOriginalRect.origin.y&&AOriginalRect.origin.y<self.superview.frame.size.height) {
            //计算拖动的比率
            if (LastPoint.x-self.superview.center.x==0) {
                AXFloat=0;
            }
            else
                AXFloat=(point.x-LastPoint.x)/(LastPoint.x-self.superview.center.x);
            if (LastPoint.y-self.superview.center.y==0) {
                AYFloat=0;
            }else
                AYFloat=(point.y-LastPoint.y)/(LastPoint.y-self.superview.center.y);
            self.frame=AOriginalRect;
            LastPoint=point;
            [self.superview bringSubviewToFront:self];
            if ([delegate respondsToSelector:@selector(DragTopRightViewWithRangeOfX:Y:)]) {
                [delegate DragTopRightViewWithRangeOfX:AXFloat Y:AYFloat];
            }
        }
    }
}
@end
