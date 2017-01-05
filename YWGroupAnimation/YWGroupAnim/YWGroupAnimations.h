//
//  YWGroupAnimations.h
//  YWAnimationDemo
//
//  Created by jin tang on 2016/12/18.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWGroupAnimAlphaBean;
@class YWGroupAnimScaleBean;
@class YWGroupAnimTranslateBean;
@class YWGroupAnimRotateBean;

@interface YWGroupAnimations : NSObject

/**
 *  渐变动画
 */
+ (CABasicAnimation *)alphaBaseAnimation:(YWGroupAnimAlphaBean *)aplhaBean withView:(UIView *)weakSelf;
+ (CAKeyframeAnimation *)alphaKeyframeAnimation:(YWGroupAnimAlphaBean *)aplhaBean withView:(UIView *)weakSelf;

/**
 *  伸缩动画
 */
+ (CABasicAnimation *)scaleBaseAnimation:(YWGroupAnimScaleBean *)scaleBean withView:(UIView *)weakSelf;
+ (CAKeyframeAnimation *)scaleKeyframeAnimation:(YWGroupAnimScaleBean *)scaleBean withView:(UIView *)weakSelf;

/**
 *  位移动画
 */
+ (CABasicAnimation *)translateBaseAnimation:(YWGroupAnimTranslateBean *)transBean withView:(UIView *)weakSelf;
+ (CAKeyframeAnimation *)translateKeyframeAnimation:(YWGroupAnimTranslateBean *)transBean withView:(UIView *)weakSelf;

/**
 *  旋转动画
 */
+ (CABasicAnimation *)rotateBaseAnimation:(YWGroupAnimRotateBean *)rotateBean withView:(UIView *)weakSelf;
+ (CAKeyframeAnimation *)rotateKeyframeAnimation:(YWGroupAnimRotateBean *)rotateBean withView:(UIView *)weakSelf;

@end
