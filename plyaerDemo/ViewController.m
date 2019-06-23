//
//  ViewController.m
//  plyaerDemo
//
//  Created by LiYang on 2019/6/23.
//  Copyright © 2019 LiYang. All rights reserved.
//

#import "ViewController.h"
#import "CMPlayerView.h"
@interface ViewController ()
@property(nonatomic, strong)CMPlayerView *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPlayerView];
}

- (void)setPlayerView {
    self.playerView = [[CMPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.view addSubview:self.playerView];
    [self.playerView setPlayerUrls:@[[NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]]];
}


@end
