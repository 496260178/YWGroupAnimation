//
//  UIView+YWGroupAnimations.h
//  YWAnimationDemo
//
//  Created by jin tang on 2016/12/18.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWGroupAnimBean;

@interface UIView (YWGroupAnimations)

- (void)makeGifAnim:(NSArray *)imageValues withKeyTimes:(NSArray *)keyTimes withDuration:(CFTimeInterval)duration;
- (void)makeGroupAnim:(NSArray<YWGroupAnimBean *> *)animBeans withGroupAnimBean:(YWGroupAnimBean *)groupAnimBean;

@end
