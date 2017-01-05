//
//  UIView+YWGroupAnimations.m
//  YWGroupAnimation
//
//  Created by jin tang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import "UIView+YWGroupAnimations.h"
#import "YWGroupAnimations.h"
#import "YWGroupAnimBean.h"
#import "YWGroupAnimAlphaBean.h"
#import "YWGroupAnimScaleBean.h"
#import "YWGroupAnimTranslateBean.h"
#import "YWGroupAnimRotateBean.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@implementation UIView (YWGroupAnimations)

- (void)makeGifAnim:(NSArray *)imageValues withKeyTimes:(NSArray *)keyTimes withDuration:(CFTimeInterval)duration {
    NSAssert(imageValues.count == keyTimes.count, @"array must have arrays of equal size");
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    [animation setValues:imageValues];
    [animation setKeyTimes:keyTimes];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    animation.repeatCount = MAXFLOAT;
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)makeGroupAnim:(NSArray<YWGroupAnimBean *> *)animBeans withGroupAnimBean:(YWGroupAnimBean *)groupAnimBean {
    CGRect bounds = self.layer.bounds;
    CGPoint position = self.layer.position;
    CATransform3D transfrom = self.layer.transform;
    
    NSMutableArray *animations = [[NSMutableArray alloc] init];
    for (YWGroupAnimBean *animBean in animBeans) {
        if ([animBean isKindOfClass:[YWGroupAnimAlphaBean class]]) {
            [animations addObject:[YWGroupAnimations alphaBaseAnimation:(YWGroupAnimAlphaBean *)animBean withView:self]];
        } else if ([animBean isKindOfClass:[YWGroupAnimScaleBean class]]) {
            [animations addObject:[YWGroupAnimations scaleBaseAnimation:(YWGroupAnimScaleBean *)animBean withView:self]];
        } else if ([animBean isKindOfClass:[YWGroupAnimTranslateBean class]]) {
            [animations addObject:[YWGroupAnimations translateBaseAnimation:(YWGroupAnimTranslateBean *)animBean withView:self]];
        }  else if ([animBean isKindOfClass:[YWGroupAnimRotateBean class]]) {
            [animations addObject:[YWGroupAnimations rotateBaseAnimation:(YWGroupAnimRotateBean *)animBean withView:self]];
        }
    }
    
    self.layer.bounds = bounds;
    self.layer.position = position;
    self.layer.transform = transfrom;
    
    CAAnimationGroup *groupAnim = [[CAAnimationGroup alloc] init];
    groupAnim.duration = groupAnimBean.duration;
    groupAnim.repeatCount = groupAnimBean.repeatCount;
    
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    
    groupAnim.autoreverses = groupAnimBean.autoreverses;
    groupAnim.animations = animations;
    
    [self.layer addAnimation:groupAnim forKey:nil];
}

@end
