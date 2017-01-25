//
//  ViewController.h
//  OpenglEs
//
//  Created by xx on 13-5-4.
//  Copyright (c) 2013年 xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenglView.h"
#import "DragView.h"
@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet OpenglView *OPenglESView;
@property (retain, nonatomic) IBOutlet DragView *MyDragView;

@end
