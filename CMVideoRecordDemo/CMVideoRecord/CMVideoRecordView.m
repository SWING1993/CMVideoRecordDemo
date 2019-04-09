//
//  CMVideoRecordView.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "CMVideoRecordView.h"
@interface CMVideoRecordView ()

@property (nonatomic, weak) UIWindow *originKeyWindow;

@end

@implementation CMVideoRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        frame.origin.y = frame.size.height;
        self.frame = frame;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        [self initSubViews];
        self.originKeyWindow = [[UIApplication sharedApplication].delegate window];
        [self makeKeyAndVisible];
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initSubViews {
}

#pragma mark - 弹出视图
- (void)present {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = self.frame;
        rect.origin.y = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = rect;
        }];
    });
}

#pragma mark - 收起视图
- (void)dismiss:(BOOL)cancel {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = self.frame;
        rect.origin.y = self.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = rect;
        } completion:^(BOOL finished) {
            [self.originKeyWindow makeKeyAndVisible];
            [self removeFromSuperview];
            if (self.cancelBlock && cancel) {
                self.cancelBlock();
            }
        }];
    });
}

@end
