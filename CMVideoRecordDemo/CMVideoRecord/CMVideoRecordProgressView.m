//
//  CMVideoRecordProgressView.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/10.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "CMVideoRecordProgressView.h"

@implementation CMVideoRecordProgressView

-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置圆心位置
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //设置半径
    CGFloat radius = self.frame.size.width/2 - 2;
    //圆起点位置
    CGFloat startA = - M_PI_2;
    //圆终点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress/self.totolProgress;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    //设置线条宽度
    CGContextSetLineWidth(ctx, 4);
    //把路径添加到上下文
    [[UIColor greenColor] setStroke];
    //设置描边颜色
    CGContextAddPath(ctx, path.CGPath);
    //渲染
    CGContextStrokePath(ctx);
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


@end
