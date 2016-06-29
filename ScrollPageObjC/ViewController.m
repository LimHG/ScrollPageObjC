//
//  ViewController.m
//  ScrollPageObjC
//
//  Created by Mac-Mini on 2016. 6. 14..
//  Copyright © 2016년 kbj. All rights reserved.
//

#import "ViewController.h"
#import "PageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    panRecz = [[UIPanGestureRecognizer alloc]init];
    [panRecz addTarget:self action:@selector(draggedView:)];
    _panGestureView.userInteractionEnabled = true;
    [_panGestureView addGestureRecognizer:panRecz];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setPageNum];
    
    [self setScrollview];
}

//page init
- (void)setPageNum {
    // Set up the array to hold the views for each page
    pageViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; ++i) {
        [pageViews addObject:[NSNull alloc]];
    }
}

- (void)setScrollview {
    
    CGSize pagesScrollViewSize = _scView.frame.size;
    _scView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageViews.count, pagesScrollViewSize.height);
    _scView.delegate = self;
    
    [self loadVisiblePages];
}

- (void)loadVisiblePages {
    //CGFloat pageWidth = _scView.frame.size.width;
    //int page = floor((_scView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0));
    
    for (int i=0; i < pageViews.count; i++) {
        [self loadPage: i];
    }
}

- (void)loadPage:(NSInteger)page{
    if (page < 0 || page >= pageViews.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    // Load an individual page, first seeing if we've already loaded it
    PageView *pageView = [pageViews objectAtIndex: page];
    if  (pageView == (id)[NSNull null] || pageView == nil) {
        
        UIView *pageView = [self viewControllerAtIndex:(int)page];
        [_scView addSubview:pageView];
        [pageViews replaceObjectAtIndex:page withObject:pageView];
    }
}

- (PageView *)viewControllerAtIndex:(int)index {
    
    if((pageViews.count == 0) || (index >= pageViews.count)) {
        return nil;
    }
    
    CGRect frame = _scView.bounds;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0.0;
    frame = CGRectInset(frame, 20.0, 0.0);
    
    PageView *pageView = [[PageView alloc] initWithFrame:frame
                                                   Index:index
                                                CallBack:^(int index) {
        [self onButton:index];
    }];
    
    [pageView setHiddenSelectBtn:YES];
    
    return pageView;
}

- (void)onButton:(int)index{
    
    [UIView animateWithDuration:0.4 animations:^(){
        _scView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }completion:^(BOOL compl) {
        _scView.scrollEnabled = false;
        PageView *pageView = [pageViews objectAtIndex:index];
        [pageView setHiddenSelectBtn:YES];
        _panGestureView.hidden = NO;

    }];
}


-(void)draggedView:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        pangestureViewInitCenter = sender.view.center;
    }
    
    else if (sender.state == UIGestureRecognizerStateEnded) {
        
        sender.view.center = pangestureViewInitCenter;
        
        if (delScale > 0.8) {
            
            [UIView animateWithDuration:0.3 animations:^(){
                _scView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL compl) {
                _scView.scrollEnabled = NO;
            }];
        }
        
        else {
            
            [UIView animateWithDuration:0.3 animations:^() {
                _scView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL compl){
                _scView.scrollEnabled = YES;
                
                for (int i=0; i < pageViews.count; i++) {
                    PageView *pageView = (PageView *)[pageViews objectAtIndex:i];
                    [pageView setHiddenSelectBtn:NO];
                    _panGestureView.hidden = YES;
                }
            }];
        }
    }
    
    else {
        
        [self.view bringSubviewToFront:sender.view];
        CGPoint translation = [sender translationInView:self.view];
        sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y);
        [sender setTranslation:CGPointZero inView:self.view];
        
        CGFloat movedX = pangestureViewInitCenter.x - sender.view.center.x;
        delScale = 1.0 - (movedX/2) / 100;
        
        if (delScale > 0.5) {
            _scView.transform = CGAffineTransformMakeScale(delScale, delScale);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
