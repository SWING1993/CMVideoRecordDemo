//
//  CMVideoRecordView.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "CMVideoRecordView.h"
#import "CMVideoRecordPlayer.h"
#import "CMVideoRecordManager.h"
#import "CMVideoRecordProgressView.h"

@interface CMVideoRecordView ()<CMVideoRecordDelegate>

@property (nonatomic, strong) CMVideoRecordManager *recorderManager;
@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIView *recordBackView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) CMVideoRecordProgressView *progressView;
@property (nonatomic, strong) NSURL *recordVideoUrl;
@property (nonatomic, strong) NSURL *recordVideoOutPutUrl;
@property (nonatomic, assign) BOOL videoCompressComplete;

@end

@implementation CMVideoRecordView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 初始化视图
- (void)initSubViews {
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    _recorderManager = [[CMVideoRecordManager alloc] init];
    _recorderManager.delegate = self;
    [_contentView.layer addSublayer:self.recorderManager.preViewLayer];
    _recorderManager.preViewLayer.frame = self.view.bounds;
    [_contentView addSubview:self.recordBackView];
    [_contentView addSubview:self.backButton];
    [_contentView addSubview:self.tipLabel];
    [_contentView addSubview:self.switchCameraButton];
    [_contentView addSubview:self.progressView];
    [_contentView addSubview:self.recordBtn];
    [_contentView addSubview:self.focusImageView];
    [_contentView bringSubviewToFront:_recordBtn];
    [self addFocusGensture];
}

#pragma mark - 点按时聚焦

- (void)addFocusGensture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_contentView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point= [tapGesture locationInView:self.contentView];
    if (150 < point.y && point.y < self.view.frame.size.height - 200) {
        [self setFocusCursorWithPoint:point];
        [self.recorderManager setFoucusWithPoint:point];
    }
}

-(void)setFocusCursorWithPoint:(CGPoint)point {
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.focusImageView.alpha = 1;
        self.focusImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(autoHideFocusImageView) withObject:nil afterDelay:1];
    }];
}

- (void)autoHideFocusImageView {
    self.focusImageView.alpha = 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _recorderManager.preViewLayer.frame = self.view.bounds;
}

- (UIImageView *)focusImageView {
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"record_video_focus"]];
        _focusImageView.alpha = 0;
        _focusImageView.frame = CGRectMake(0, 0, 75, 75);
    }
    return _focusImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"record_video_back"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(60, self.recordBtn.center.y - 18, 36, 36);
        [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (CMVideoRecordProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[CMVideoRecordProgressView alloc] initWithFrame:self.recordBackView.frame];
    }
    return _progressView;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraButton setImage:[UIImage imageNamed:@"record_video_camera"] forState:UIControlStateNormal];
        _switchCameraButton.frame = CGRectMake(self.view.frame.size.width - 20 - 28, 40, 30, 28);
        [_switchCameraButton addTarget:self action:@selector(clickSwitchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}

- (UIView *)recordBackView {
    if (!_recordBackView) {
        CGRect rect = self.recordBtn.frame;
        CGFloat gap = 7.5;
        rect.size = CGSizeMake(rect.size.width + gap*2, rect.size.height + gap*2);
        rect.origin = CGPointMake(rect.origin.x - gap, rect.origin.y - gap);
        _recordBackView = [[UIView alloc]initWithFrame:rect];
        _recordBackView.backgroundColor = [UIColor whiteColor];
        _recordBackView.alpha = 0.6;
        [_recordBackView.layer setCornerRadius:_recordBackView.frame.size.width/2];
    }
    return _recordBackView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 180)/2, self.recordBackView.frame.origin.y - 30, 180, 20)];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"轻触拍照,按住摄像";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipLabel;
}

-(UIView *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[UIView alloc] init];
        CGFloat deta = [UIScreen mainScreen].bounds.size.width/375;
        CGFloat width = 60.0*deta;
        _recordBtn.frame = CGRectMake((self.view.frame.size.width - width)/2, self.view.frame.size.height - 107*deta, width, width);
        [_recordBtn.layer setCornerRadius:_recordBtn.frame.size.width/2];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        // 长按时间
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startRecord:)];
        [_recordBtn addGestureRecognizer:press];
        // 点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
        [_recordBtn addGestureRecognizer:tap];
        _recordBtn.userInteractionEnabled = YES;
    }
    return _recordBtn;
}

#pragma mark - 点击事件
- (void)clickSwitchCamera {
    [self.recorderManager switchCamera];
}

- (void)clickBackButton {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)takePicture:(UITapGestureRecognizer *)gesture {
    [self.recorderManager takePhoto];
}

#pragma mark - 开始录制
- (void)startRecord:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.recordVideoUrl = nil;
        self.videoCompressComplete = NO;
        self.recordVideoOutPutUrl = nil;
        [self startRecordAnimate];
        CGRect rect = self.progressView.frame;
        rect.size = CGSizeMake(self.recordBackView.frame.size.width - 3, self.recordBackView.frame.size.height - 3);
        rect.origin = CGPointMake(self.recordBackView.frame.origin.x + 1.5, self.recordBackView.frame.origin.y + 1.5);
        self.progressView.frame = self.recordBackView.frame;
        self.backButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.switchCameraButton.hidden = YES;
        NSURL *url = [NSURL fileURLWithPath:[CMVideoRecordManager cacheFilePath:YES]];
        [self.recorderManager startRecordToFile:url];
    } else if(gesture.state >= UIGestureRecognizerStateEnded) {
        [self stopRecord];
    } else if(gesture.state >= UIGestureRecognizerStateCancelled) {
        [self stopRecord];
    } else if(gesture.state >= UIGestureRecognizerStateFailed) {
        [self stopRecord];
    }
}

- (void)startRecordAnimate {
    [UIView animateWithDuration:0.2 animations:^{
        self.recordBtn.transform = CGAffineTransformMakeScale(0.66, 0.66);
        self.recordBackView.transform = CGAffineTransformMakeScale(6.5/5, 6.5/5);
    }];
}

#pragma mark - 停止录制
- (void)stopRecord {
    [self.recorderManager stopCurrentVideoRecording];
}

#pragma mark - 录制结束循环播放视频
- (void)showVedio:(NSURL *)playUrl {
    CMVideoRecordPlayer *playView= [[CMVideoRecordPlayer alloc] initWithFrame:self.view.bounds];
    playView.backgroundColor = [UIColor blackColor];
    [_contentView addSubview:playView];
    playView.playUrl = playUrl;
    __weak typeof(self) weakSelf = self;
    playView.cancelBlock = ^{
        [weakSelf clickCancel];
    };
    playView.confirmBlock = ^{
        if (!weakSelf.videoCompressComplete) {
            return ;
        }
        [weakSelf saveVideo];
        if (weakSelf.videoCompletionBlock && weakSelf.recordVideoOutPutUrl) {
            weakSelf.videoCompletionBlock(weakSelf.recordVideoOutPutUrl);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    };
}

- (void)saveVideo {
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([self.recordVideoUrl path])) {
        //保存视频到相簿
        UISaveVideoAtPathToSavedPhotosAlbum([self.recordVideoUrl path], self,
                                            @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存视频完成");
}

- (void)savePhoto:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if (error != NULL) {
        msg = @"保存图片失败" ;
    } else {
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@", msg);
}

- (void)compressVideo {
    __weak typeof(self) instance = self;
    [self.recorderManager compressVideo:self.recordVideoUrl complete:^(BOOL success, NSURL *outputUrl) {
        if (success && outputUrl) {
            instance.recordVideoOutPutUrl = outputUrl;
        }
        instance.videoCompressComplete = YES;
    }];
}

#pragma mark - 取消录制的视频
- (void)clickCancel {
    self.recordBtn.transform = CGAffineTransformMakeScale(1, 1);
    self.recordBackView.transform = CGAffineTransformMakeScale(1, 1);
    [self.recorderManager prepareForRecord];
    self.backButton.hidden = NO;
    self.tipLabel.hidden = NO;
    self.switchCameraButton.hidden = NO;
}

#pragma mark - JCVideoRecordManagerDelegate method
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    [self.progressView setProgress:0];
    if (!error) {
        //播放视频
        self.recordVideoUrl = outputFileURL;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showVedio:outputFileURL];
        });
        [self compressVideo];
    }
}

- (void)recordTimeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime {
    self.progressView.totolProgress = totalTime;
    self.progressView.progress = currentTime;
}

- (void)takePhotoCompletedWithImage:(UIImage *)image error:(NSError *)error {
    CMVideoRecordPlayer *playView= [[CMVideoRecordPlayer alloc] initWithFrame:self.view.bounds];
    playView.backgroundColor = [UIColor blackColor];
    [_contentView addSubview:playView];
    playView.image = image;
    __weak typeof(self) weakSelf = self;
    playView.cancelBlock = ^{
        [weakSelf clickCancel];
    };
    playView.confirmBlock = ^{
        [weakSelf savePhoto:image];
        if (weakSelf.photoCompletionBlock) {
            weakSelf.photoCompletionBlock(image);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    };
}

- (void)dealloc {
    NSLog(@"orz   dealloc");
}

@end
