//
//  PageView.h
//  ScrollPageObjC
//
//  Created by Mac-Mini on 2016. 6. 14..
//  Copyright © 2016년 kbj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectBlock)(int idx);

@interface PageView : UIView {
    
    SelectBlock block;
    int index;
}

@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *pageSelectBtn;

- (instancetype)initWithFrame:(CGRect)frame Index:(int)pageIndex CallBack:(SelectBlock)_block;

- (void)setHiddenSelectBtn:(BOOL)val;

@end
