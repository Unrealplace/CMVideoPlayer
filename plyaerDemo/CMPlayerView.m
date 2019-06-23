//
//  CMPlayerView.m
//  美平米
//
//  Created by mpm on 2019/6/21.
//  Copyright © 2019 com.imicrothink. All rights reserved.
//

#import "CMPlayerView.h"
#import <AVKit/AVKit.h>

@interface CMPlayerView()
@property(nonatomic, strong)AVPlayerItem *playerItem;
@property(nonatomic, strong)AVPlayerLayer *playerLayer;
@property(nonatomic, strong)AVPlayer     *player;
@property(nonatomic, strong)AVURLAsset   *videoAsset;

@property(nonatomic, strong)NSArray<NSURL*> *urls;
@property(nonatomic, assign)NSInteger urlIdx;
@property(nonatomic, strong)UIImageView *firstFrameImgV;

@end

@implementation CMPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
        [self setUIWithFrame:frame];
    }
    return self;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.playerItem=nil;
}

- (void)setUIWithFrame:(CGRect)frame {
    [self.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.firstFrameImgV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addSubview:self.firstFrameImgV];
}

- (AVPlayer*)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 0.0f;
    }
    return _player;
}

- (AVPlayerLayer*)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playerLayer;
}

- (UIImageView*)firstFrameImgV {
    if (!_firstFrameImgV) {
        _firstFrameImgV = [[UIImageView alloc] init];
        _firstFrameImgV.alpha = 0.0f;
    }
    return _firstFrameImgV;
}

- (void)setPlayerUrls:(NSArray<NSURL *> *)urls {
    self.urls = urls;
    self.urlIdx = 0;
    [self updatePlayerWithUrl:self.urls[self.urlIdx]];
}

- (void)updatePlayerWithUrl:(NSURL *)url {
    UIImage * image = [self thumbnailImageForVideo:url atTime:0];
    [self showFirstFrameImageViewWithImage:image];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self addObserverAndNotification];
}

- (void)showFirstFrameImageViewWithImage:(UIImage*)image {
    if (image) {
        self.firstFrameImgV.image = image;
        self.firstFrameImgV.alpha = 1;
    }else {
        self.firstFrameImgV.alpha = 0;
    }
}

- (void)play {
    [self.player play];
}

- (void)addObserverAndNotification {
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionNew context:nil];// 观察status属性， 一共有三种属性
    [self.playerItem addObserver:self
                      forKeyPath:@"loadedTimeRanges"
                         options:NSKeyValueObservingOptionNew context:nil];// 观察缓冲进度
    [self addNotification];
}

#pragma mark KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备播放");
            // CMTime 本身是一个结构体
            CMTime duration = item.duration; // 获取视频长度
            NSLog(@"%.2f", CMTimeGetSeconds(duration));
            // 设置视频时间
//            [self setMaxDuration:CMTimeGetSeconds(duration)];
            // 播放
            [self play];
            [self showFirstFrameImageViewWithImage:nil];
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else {
            NSLog(@"AVPlayerStatusUnknown");
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {

    }
}

#pragma mark 添加通知
- (void)addNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成通知");
    self.urlIdx++;
    if (self.urlIdx>self.urls.count-1) {
        self.urlIdx = 0;
    }
    [self updatePlayerWithUrl:self.urls[self.urlIdx]];

}

- (void)enterForegroundNotification:(NSNotification *)notification {
    
}

- (void)enterBackgroundNotification:(NSNotification *)notification {
    
}

- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


@end
