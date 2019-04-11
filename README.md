# CMVideoRecordDemo
仿照微信の长按录制小视频和点击拍照的组件

```objc
- (void)videoRecordAction {
    CMVideoRecordView *controller = [[CMVideoRecordView alloc] init];
    controller.cancelBlock = ^{
        NSLog(@"CMVideoRecordView 取消录制");
    };
    controller.videoCompletionBlock = ^(NSURL *fileUrl) {
        NSLog(@"CMVideoRecordView 完成录制：%@",fileUrl);
    };
    controller.photoCompletionBlock = ^(UIImage * _Nonnull image) {
        NSLog(@"CMVideoRecordView 拍照完成");
    };
    [self presentViewController:controller animated:true completion:NULL];
}

```