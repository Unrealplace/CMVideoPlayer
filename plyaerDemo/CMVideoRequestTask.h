//
//  CMVideoRequestTask.h
//  plyaerDemo
//
//  Created by LiYang on 2019/6/23.
//  Copyright © 2019 LiYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CMVideoRequestTask;
@protocol CMVideoRequestTaskDelegate <NSObject>

- (void)task:(CMVideoRequestTask *)task didReceiveVideoLength:(NSUInteger)videoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(CMVideoRequestTask *)task;
- (void)didFinishLoadingWithTask:(CMVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(CMVideoRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface CMVideoRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL                      *url;
@property (nonatomic, readonly        ) NSUInteger                 offset;

@property (nonatomic, readonly        ) NSUInteger                 videoLength;
@property (nonatomic, readonly        ) NSUInteger                 downLoadingOffset;
@property (nonatomic, strong, readonly) NSString                   *mimeType;
@property (nonatomic, assign)           BOOL                       isFinishLoad;

@property (nonatomic, weak            ) id <CMVideoRequestTaskDelegate> delegate;


- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;

@end

NS_ASSUME_NONNULL_END
