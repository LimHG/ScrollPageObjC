//
//  ViewController.h
//  ScrollPageObjC
//
//  Created by Mac-Mini on 2016. 6. 14..
//  Copyright © 2016년 kbj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>{
    UIPanGestureRecognizer *panRecz;
    
    NSInteger           pageCount;
    NSMutableArray     *pageViews;
    CGPoint             pangestureViewInitCenter;
    CGFloat             delScale;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scView;
@property (weak, nonatomic) IBOutlet UIView *panGestureView;

@end

