//
//  CMVideoRecordPlayer.h
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/10.
//  Copyright © 2019 MPM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CMVideoRecordPlayerCancelBlock)(void);
typedef void(^CMVideoRecordPlayerConfirmBlock)(void);

@interface CMVideoRecordPlayer : UIView

@property (nonatomic, copy) CMVideoRecordPlayerCancelBlock cancelBlock;
@property (nonatomic, copy) CMVideoRecordPlayerConfirmBlock confirmBlock;
@property (nonatomic, strong) NSURL *playUrl;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIImage *image;


@end

NS_ASSUME_NONNULL_END
