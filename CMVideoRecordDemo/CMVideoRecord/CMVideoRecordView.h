//
//  CMVideoRecordView.h
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CMVideoRecordDismissBlock)(void);
typedef void(^CMVideoRecordVideoCompletionBlock)(NSURL *fileUrl);
typedef void(^CMVideoRecordPhotoCompletionBlock)(UIImage *image);

@interface CMVideoRecordView : UIViewController

@property (nonatomic, copy) CMVideoRecordDismissBlock cancelBlock;
@property (nonatomic, copy) CMVideoRecordVideoCompletionBlock videoCompletionBlock;
@property (nonatomic, copy) CMVideoRecordPhotoCompletionBlock photoCompletionBlock;

@end

NS_ASSUME_NONNULL_END
