//
//  CMVideoRecordManager.h
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/10.
//  Copyright © 2019 MPM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CMVideoRecordDelegate <NSObject>

// 录制结束
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;

// 录制时间
- (void)recordTimeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;

@end

@interface CMVideoRecordManager : NSObject

@property (nonatomic, weak) id<CMVideoRecordDelegate> delegate;

// 摄像头视图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

// 准备录制
- (void)prepareForRecord;

// 开始录制
- (void)startRecordToFile:(NSURL *)outPutFile;

// 停止录制
- (void)stopCurrentVideoRecording;

// 切换摄像头
- (void)switchCamera;

// 设置对焦
- (void)setFoucusWithPoint:(CGPoint)point;

//压缩视频
- (void)compressVideo:(NSURL *)inputFileURL complete:(void(^)(BOOL success, NSURL* outputUrl))complete;

+ (CGFloat)getfileSize:(NSString *)filePath;

+ (void)getCameraAuth:(void(^)(BOOL boolValue, NSString *tipText))isAuthorized;

// 缓存路径
+ (NSString*)cacheFilePath:(BOOL)input;

@end

NS_ASSUME_NONNULL_END
