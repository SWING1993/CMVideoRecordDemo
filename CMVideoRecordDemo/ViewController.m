//
//  ViewController.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "ViewController.h"
#import "CMVideoRecord/CMVideoRecordView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    [button setTitle:@"录制" forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - 25, CGRectGetHeight(self.view.frame)/2 - 25, 50, 50);
    [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [button addTarget:self action:@selector(videoRecordAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)videoRecordAction {
    CMVideoRecordView *controller = [[CMVideoRecordView alloc] init];
        controller.cancelBlock = ^{
            NSLog(@"CMVideoRecordView 取消录制");
        };
        controller.completionBlock = ^(NSURL *fileUrl) {
            NSLog(@"CMVideoRecordView 完成录制：%@",fileUrl);
        };
    [self presentViewController:controller animated:true completion:NULL];
}

@end
