//
//  DragView.h
//  OpenglEs
//
//  Created by xx on 13-5-6.
//  Copyright (c) 2013年 xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DragViewDelegate;
@interface DragView : UIView
{
        CGPoint LastPoint;//鼠标按下起点
        id <DragViewDelegate> delegate;
}
@property (nonatomic, assign) id <DragViewDelegate> delegate;
@end
@protocol DragViewDelegate <NSObject>
@required
-(void)DragTopRightViewWithRangeOfX:(float)ARangeOfX Y:(float)ARangeOfY;

@end
