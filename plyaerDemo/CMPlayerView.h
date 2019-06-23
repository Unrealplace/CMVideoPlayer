//
//  CMPlayerView.h
//  美平米
//
//  Created by mpm on 2019/6/21.
//  Copyright © 2019 com.imicrothink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPlayerView : UIView

- (void)setPlayerUrls:(NSArray<NSURL*>*)urls;
- (void)updatePlayerWithUrl:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END
