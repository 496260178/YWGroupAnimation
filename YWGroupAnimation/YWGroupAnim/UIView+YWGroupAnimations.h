//
//  UIView+YWGroupAnimations.h
//  YWGroupAnimation
//
//  Created by jin tang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWGroupAnimBean;

@interface UIView (YWGroupAnimations)

- (void)makeGifAnim:(NSArray *)imageValues withKeyTimes:(NSArray *)keyTimes withDuration:(CFTimeInterval)duration;
- (void)makeGroupAnim:(NSArray<YWGroupAnimBean *> *)animBeans withGroupAnimBean:(YWGroupAnimBean *)groupAnimBean;

@end
