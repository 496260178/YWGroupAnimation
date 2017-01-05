//
//  ViewController.m
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import "ViewController.h"
#import "YWGroupAnimations.h"
#import "YWGroupAnimConfig.h"
#import "YWGroupAnimInfo.h"
#import "UIView+YWGroupAnimations.h"

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@property (nonatomic, strong) UIImageView *animationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClicked:)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.animationView];
    [self playAnim];
}

- (void)playAnim {
    YWGroupAnimConfig *config = [[YWGroupAnimConfig alloc] init];
    [config xmlConfigParserWithParseCompletionBlock:^(BOOL isSucc, YWGroupAnimInfo *info) {
        UIImage *image = [UIImage imageWithCGImage:(__bridge CGImageRef)([info.gifAnimImages firstObject])];
        CGSize size = CGSizeMake(image.size.height/2.0f, image.size.height/2.0f);
        
        self.animationView.frame = CGRectMake(SCREEN_WIDTH-size.width-5.0f, SCREEN_HEIGHT-size.height-100.0f, size.width, size.height);
        self.animationView.image = image;
        
        [self.animationView makeGifAnim:info.gifAnimImages withKeyTimes:info.gifAnimaKeyTimes withDuration:info.gifAnimDuration];
        [self.animationView makeGroupAnim:info.groupAnimBeans withGroupAnimBean:info.animBean];
    }];
}

- (void)onViewClicked:(UITapGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if ([self.animationView.layer.presentationLayer hitTest:touchPoint]) {
        NSLog(@"点中🌶🌶🌶!!!");
    }
}

- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] init];
        _animationView.userInteractionEnabled = YES;
    }
    return _animationView;
}

@end
