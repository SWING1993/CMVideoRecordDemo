//
//  CMVideoRecordPlayer.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/10.
//  Copyright © 2019 MPM. All rights reserved.
//

#import "CMVideoRecordPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface CMVideoRecordPlayer ()

@property (nonatomic, strong) CALayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CMVideoRecordPlayer

- (CALayer *)playerLayer {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    return playerLayer;
}

- (void)playerButtons {
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375.0;
    CGFloat width = 65.0 * scale;
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.alpha = 0;
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"record_video_cancel"] forState:UIControlStateNormal];
    _cancelButton.frame = CGRectMake((self.frame.size.width - width)/2, self.frame.size.height - 150 * scale, width, width);
    [_cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
   
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
     _confirmButton.alpha = 0;
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"record_video_confirm"] forState:UIControlStateNormal];
    _confirmButton.frame = CGRectMake((self.frame.size.width - width)/2, _cancelButton.frame.origin.y , width, width);
    [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
}

- (void)clickConfirm {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self.player pause];
    [self removeFromSuperview];
}

- (void)clickCancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self.player pause];
    [self removeFromSuperview];
}

- (void)showPlayerButtons {
    CGFloat deta = [UIScreen mainScreen].bounds.size.width/375.0;
    CGFloat width = 60.0*deta;
    CGRect cancelRect = _cancelButton.frame;
    CGRect confirmRect = _confirmButton.frame;
    cancelRect.origin.x = 60*deta;
    confirmRect.origin.x = self.frame.size.width - 60*deta - width;
    [UIView animateWithDuration:0.2 animations:^{
        self.cancelButton.frame = cancelRect;
        self.confirmButton.frame = confirmRect;
        self.confirmButton.alpha = 1;
        self.cancelButton.alpha = 1;
    }];
}

- (void)setPlayUrl:(NSURL *)playUrl {
    _playUrl = playUrl;
    if (!self.player) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
    }
    [self.layer addSublayer:self.playerLayer];
    if (!_confirmButton) {
        [self playerButtons];
    }
    [self showPlayerButtons];
    [self.player play];
}

- (void)playbackFinished:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.frame = self.bounds;
        [self addSubview:_imageView];
    }
    if (!_confirmButton) {
        [self playerButtons];
    }
    [self showPlayerButtons];
}

- (void)dealloc {
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
