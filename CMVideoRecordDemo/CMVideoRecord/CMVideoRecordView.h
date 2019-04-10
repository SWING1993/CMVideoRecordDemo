//
//  CMVideoRecordView.h
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CMVideoRecordViewDismissBlock)(void);
typedef void(^CMVideoRecordViewCompletionBlock)(NSURL *fileUrl);

@interface CMVideoRecordView : UIViewController

@property (nonatomic, copy) CMVideoRecordViewDismissBlock cancelBlock;
@property (nonatomic, copy) CMVideoRecordViewCompletionBlock completionBlock;

@end

NS_ASSUME_NONNULL_END
