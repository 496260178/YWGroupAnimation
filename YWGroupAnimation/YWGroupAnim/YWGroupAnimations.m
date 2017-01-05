//
//  YWGroupAnimations.m
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWGroupAnimations.h"
#import "YWGroupAnimBean.h"
#import "YWGroupAnimAlphaBean.h"
#import "YWGroupAnimScaleBean.h"
#import "YWGroupAnimTranslateBean.h"
#import "YWGroupAnimRotateBean.h"
#import "NSBKeyframeAnimationFunctions.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

#define kFPS 60

typedef double(^NSBKeyframeAnimationFunctionBlock)(double t, double b, double c, double d);
typedef NSBKeyframeAnimationFunctionBlock functionBlock;

static NSMutableDictionary<NSString *, NSBKeyframeAnimationFunctionBlock> *easingFuncBlocks;

@implementation YWGroupAnimations

+ (void)initialize {
    easingFuncBlocks = [[NSMutableDictionary<NSString *, NSBKeyframeAnimationFunctionBlock> alloc] init];
    [self addKeyframeAnimationFunctionBlocks:easingFuncBlocks];
}

+ (CABasicAnimation *)alphaBaseAnimation:(YWGroupAnimAlphaBean *)aplhaBean withView:(UIView *)weakSelf {
    CABasicAnimation *animation = [self setBaseAnimationWithKeyPath:@"opacity" withAnimBean:aplhaBean];
    
    animation.fromValue = @(aplhaBean.fromAlpha);
    animation.toValue = @(aplhaBean.toAlpha);
    
    return animation;
}

+ (CAKeyframeAnimation *)alphaKeyframeAnimation:(YWGroupAnimAlphaBean *)aplhaBean withView:(UIView *)weakSelf {
    CAKeyframeAnimation *animation = [self setKeyframeAnimationWithKeyPath:@"opacity" withAnimBean:aplhaBean];
    
    animation.values = [self createValueArray:@(aplhaBean.fromAlpha) toValue:@(aplhaBean.toAlpha) duration:aplhaBean.duration easeingFunction:aplhaBean.easingFuction];
    
    return animation;
}

+ (CABasicAnimation *)scaleBaseAnimation:(YWGroupAnimScaleBean *)scaleBean withView:(UIView *)weakSelf {
    CABasicAnimation *animation = [self setBaseAnimationWithKeyPath:@"bounds" withAnimBean:scaleBean];
    
    CGSize orignSize = weakSelf.layer.bounds.size;
    CGRect fromRect = CGRectMake(0.0f, 0.f, MAX(orignSize.width*scaleBean.fromXScale, 0.0f), MAX(orignSize.height*scaleBean.fromYScale, 0.0f));
    CGRect toRect = CGRectMake(0.0f, 0.f, MAX(orignSize.width*scaleBean.toXScale, 0.0f), MAX(orignSize.height*scaleBean.toYScale, 0.0f));
    
    animation.fromValue = [NSValue valueWithCGRect:fromRect];
    animation.toValue = [NSValue valueWithCGRect:toRect];
    
    return animation;
}

+ (CAKeyframeAnimation *)scaleKeyframeAnimation:(YWGroupAnimScaleBean *)scaleBean withView:(UIView *)weakSelf {
    CAKeyframeAnimation *animation = [self setKeyframeAnimationWithKeyPath:@"bounds" withAnimBean:scaleBean];
    
    CGSize orignSize = weakSelf.layer.bounds.size;
    CGRect fromRect = CGRectMake(0.0f, 0.f, MAX(orignSize.width*scaleBean.fromXScale, 0.0f), MAX(orignSize.height*scaleBean.fromYScale, 0.0f));
    CGRect toRect = CGRectMake(0.0f, 0.f, MAX(orignSize.width*scaleBean.toXScale, 0.0f), MAX(orignSize.height*scaleBean.toYScale, 0.0f));
    
    animation.values = [self createValueArray:[NSValue valueWithCGRect:fromRect] toValue:[NSValue valueWithCGRect:toRect] duration:scaleBean.duration easeingFunction:scaleBean.easingFuction];
    
    return animation;
}

+ (CABasicAnimation *)translateBaseAnimation:(YWGroupAnimTranslateBean *)transBean withView:(UIView *)weakSelf {
    CABasicAnimation *animation = [self setBaseAnimationWithKeyPath:@"position" withAnimBean:transBean];
    
    CGPoint fromPosition = weakSelf.layer.position;
    fromPosition.x += transBean.fromXDelta;
    fromPosition.y += transBean.fromYDelta;
    
    CGPoint toPosition = weakSelf.layer.position;
    toPosition.x += transBean.toXDelta;
    toPosition.y += transBean.toYDelta;
    
    animation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    animation.toValue = [NSValue valueWithCGPoint:toPosition];
    
    return animation;
}

+ (CAKeyframeAnimation *)translateKeyframeAnimation:(YWGroupAnimTranslateBean *)transBean withView:(UIView *)weakSelf {
    CAKeyframeAnimation *animation = [self setKeyframeAnimationWithKeyPath:@"position" withAnimBean:transBean];
    
    CGPoint fromPosition = weakSelf.layer.position;
    fromPosition.x += transBean.fromXDelta;
    fromPosition.y += transBean.fromYDelta;
    
    CGPoint toPosition = weakSelf.layer.position;
    toPosition.x += transBean.toXDelta;
    toPosition.y += transBean.toYDelta;
    
    animation.path = createValueArray([NSValue valueWithCGPoint:fromPosition], [NSValue valueWithCGPoint:toPosition], transBean.duration, transBean.easingFuction);
    
    return animation;
}

+ (CABasicAnimation *)rotateBaseAnimation:(YWGroupAnimRotateBean *)rotateBean withView:(UIView *)weakSelf {
    CABasicAnimation *animation = [self setBaseAnimationWithKeyPath:@"transform.rotation.z" withAnimBean:rotateBean];
    
    CATransform3D transform = weakSelf.layer.transform;
    CGFloat orignRotation = atan2(transform.m12, transform.m11);
    
    CGFloat fromRotation = orignRotation + degreesToRadians(rotateBean.fromDegrees);
    CGFloat toRotation = orignRotation + degreesToRadians(rotateBean.toDegrees);
    
    animation.fromValue = @(fromRotation);
    animation.toValue = @(toRotation);
    
    weakSelf.layer.anchorPoint = CGPointMake(rotateBean.pivotX, rotateBean.pivotY);
    
    return animation;
}

+ (CAKeyframeAnimation *)rotateKeyframeAnimation:(YWGroupAnimRotateBean *)rotateBean withView:(UIView *)weakSelf {
    CAKeyframeAnimation *animation = [self setKeyframeAnimationWithKeyPath:@"transform.rotation.z" withAnimBean:rotateBean];
    
    CATransform3D transform = weakSelf.layer.transform;
    CGFloat orignRotation = atan2(transform.m12, transform.m11);
    
    CGFloat fromRotation = orignRotation + degreesToRadians(rotateBean.fromDegrees);
    CGFloat toRotation = orignRotation + degreesToRadians(rotateBean.toDegrees);
    
    weakSelf.layer.anchorPoint = CGPointMake(rotateBean.pivotX, rotateBean.pivotY);
    
    animation.values = [self createValueArray:@(fromRotation) toValue:@(toRotation) duration:rotateBean.duration easeingFunction:rotateBean.easingFuction];
    
    return animation;
}

+ (CABasicAnimation *)setBaseAnimationWithKeyPath:(NSString *)keyPath withAnimBean:(YWGroupAnimBean *)animBean {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    [self setAnimation:animation withAnimBean:animBean];
    
    if ([animBean.easingFuction isEqualToString:@"easeIn"]) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else if ([animBean.easingFuction isEqualToString:@"easeOut"]) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    } else if ([animBean.easingFuction isEqualToString:@"easeInOut"]) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    
    return animation;
}

+ (CAKeyframeAnimation *)setKeyframeAnimationWithKeyPath:(NSString *)keyPath withAnimBean:(YWGroupAnimBean *)animBean {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    [self setAnimation:animation withAnimBean:animBean];
    
    return animation;
}

+ (void)setAnimation:(CAAnimation *)animation withAnimBean:(YWGroupAnimBean *)animBean {
    animation.beginTime = animBean.beginTime;
    if (animBean.autoreverses) {
        animation.duration = animBean.duration/animBean.repeatCount/2;
    } else {
        animation.duration = animBean.duration/animBean.repeatCount;
    }
    
    animation.repeatCount = animBean.repeatCount;
    animation.autoreverses = animBean.autoreverses;
    
    animation.removedOnCompletion = animBean.removedOnCompletion;
    animation.fillMode = animBean.fillMode;
}

static CGPathRef createValueArray(id fromValue, id toValue, CGFloat duration, NSString *funcName) {
    if (fromValue && toValue && duration && [fromValue isKindOfClass:[NSValue class]] && [toValue isKindOfClass:[NSValue class]]) {
        NSString *valueType = [NSString stringWithCString:[fromValue objCType] encoding:NSStringEncodingConversionAllowLossy];
        if ([valueType rangeOfString:@"CGPoint"].location == 1) {
            CGPoint fromPoint = [fromValue CGPointValue];
            CGPoint toPoint = [toValue CGPointValue];
            return createPathFromXYValues([YWGroupAnimations valueArrayForStartValue:fromPoint.x endValue:toPoint.x
                                                                            duration:duration easeingFunction:funcName],
                                          [YWGroupAnimations valueArrayForStartValue:fromPoint.y endValue:toPoint.y
                                                                            duration:duration easeingFunction:funcName]);
            
        } else if ([valueType rangeOfString:@"CGSize"].location == 1) {
            CGSize fromSize = [fromValue CGSizeValue];
            CGSize toSize = [toValue CGSizeValue];
            return createPathFromXYValues([YWGroupAnimations valueArrayForStartValue:fromSize.width endValue:toSize.width
                                                                            duration:duration easeingFunction:funcName],
                                          [YWGroupAnimations valueArrayForStartValue:fromSize.height endValue:toSize.height duration:duration easeingFunction:funcName]);
        }
    }
    return nil;
}

+ (NSArray *)createValueArray:(id)fromValue toValue:(id)toValue duration:(CGFloat)duration easeingFunction:(NSString *)funcName {
    NSArray *values;
    if (fromValue && toValue && duration) {
        if ([fromValue isKindOfClass:[NSNumber class]] && [toValue isKindOfClass:[NSNumber class]]) {
            values = [self valueArrayForStartValue:[fromValue floatValue] endValue:[toValue floatValue] duration:duration easeingFunction:funcName];
        } else if ([fromValue isKindOfClass:[UIColor class]] && [toValue isKindOfClass:[UIColor class]]) {
            const CGFloat *fromComponents = CGColorGetComponents(((UIColor*)fromValue).CGColor);
            const CGFloat *toComponents = CGColorGetComponents(((UIColor*)toValue).CGColor);
            values = [self createColorArrayFromRed:
                      [self valueArrayForStartValue:fromComponents[0] endValue:toComponents[0] duration:duration easeingFunction:funcName]
                                             green:
                      [self valueArrayForStartValue:fromComponents[1] endValue:toComponents[1] duration:duration easeingFunction:funcName]
                                              blue:
                      [self valueArrayForStartValue:fromComponents[2] endValue:toComponents[2] duration:duration easeingFunction:funcName]
                                             alpha:
                      [self valueArrayForStartValue:fromComponents[3] endValue:toComponents[3] duration:duration easeingFunction:funcName]];
        } else if ([fromValue isKindOfClass:[NSValue class]] && [toValue isKindOfClass:[NSValue class]]) {
            NSString *valueType = [NSString stringWithCString:[fromValue objCType] encoding:NSStringEncodingConversionAllowLossy];
            if ([valueType rangeOfString:@"CGRect"].location == 1) {
                CGRect fromRect = [fromValue CGRectValue];
                CGRect toRect = [toValue CGRectValue];
                values = [self createRectArrayFromXValues:
                          [self valueArrayForStartValue:fromRect.origin.x endValue:toRect.origin.x duration:duration easeingFunction:funcName]
                                                  yValues:
                          [self valueArrayForStartValue:fromRect.origin.y endValue:toRect.origin.y duration:duration easeingFunction:funcName]
                                                   widths:
                          [self valueArrayForStartValue:fromRect.size.width endValue:toRect.size.width duration:duration easeingFunction:funcName]
                                                  heights:
                          [self valueArrayForStartValue:fromRect.size.height endValue:toRect.size.height duration:duration easeingFunction:funcName]];
                
            } else if ([valueType rangeOfString:@"CATransform3D"].location == 1) {
                CATransform3D fromTransform = [fromValue CATransform3DValue];
                CATransform3D toTransform = [toValue CATransform3DValue];
                
                values = [self createTransformArrayFromM11:
                          [self valueArrayForStartValue:fromTransform.m11 endValue:toTransform.m11 duration:duration easeingFunction:funcName]
                                                       M12:
                          [self valueArrayForStartValue:fromTransform.m12 endValue:toTransform.m12 duration:duration easeingFunction:funcName]
                                                       M13:
                          [self valueArrayForStartValue:fromTransform.m13 endValue:toTransform.m13 duration:duration easeingFunction:funcName]
                                                       M14:
                          [self valueArrayForStartValue:fromTransform.m14 endValue:toTransform.m14 duration:duration easeingFunction:funcName]
                                                       M21:
                          [self valueArrayForStartValue:fromTransform.m21 endValue:toTransform.m21 duration:duration easeingFunction:funcName]
                                                       M22:
                          [self valueArrayForStartValue:fromTransform.m22 endValue:toTransform.m22 duration:duration easeingFunction:funcName]
                                                       M23:
                          [self valueArrayForStartValue:fromTransform.m23 endValue:toTransform.m23 duration:duration easeingFunction:funcName]
                                                       M24:
                          [self valueArrayForStartValue:fromTransform.m24 endValue:toTransform.m24 duration:duration easeingFunction:funcName]
                                                       M31:
                          [self valueArrayForStartValue:fromTransform.m31 endValue:toTransform.m31 duration:duration easeingFunction:funcName]
                                                       M32:
                          [self valueArrayForStartValue:fromTransform.m32 endValue:toTransform.m32 duration:duration easeingFunction:funcName]
                                                       M33:
                          [self valueArrayForStartValue:fromTransform.m33 endValue:toTransform.m33 duration:duration easeingFunction:funcName]
                                                       M34:
                          [self valueArrayForStartValue:fromTransform.m34 endValue:toTransform.m34 duration:duration easeingFunction:funcName]
                                                       M41:
                          [self valueArrayForStartValue:fromTransform.m41 endValue:toTransform.m41 duration:duration easeingFunction:funcName]
                                                       M42:
                          [self valueArrayForStartValue:fromTransform.m42 endValue:toTransform.m42 duration:duration easeingFunction:funcName]
                                                       M43:
                          [self valueArrayForStartValue:fromTransform.m43 endValue:toTransform.m43 duration:duration easeingFunction:funcName]
                                                       M44:
                          [self valueArrayForStartValue:fromTransform.m44 endValue:toTransform.m44 duration:duration easeingFunction:funcName]
                          ];
            }
        }
    }
    
    return values;
}

+ (NSArray*)valueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue duration:(CGFloat)duration easeingFunction:(NSString *)funcName {
    NSUInteger steps = (NSUInteger)ceil(kFPS * duration) + 2;
    
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:steps];
    
    const double increment = 1.0 / (double)(steps - 1);
    
    double progress = 0.0,
    v = 0.0,
    value = 0.0;
    
    NSBKeyframeAnimationFunctionBlock funcBlock = [easingFuncBlocks objectForKey:funcName];
    if (!funcBlock) {
        funcBlock = ^double(double t, double b, double c, double d) {
            return c*(t/=d) + b;
        };
    }
    
    for (NSUInteger i = 0; i < steps; i++) {
        v = funcBlock(duration * progress * 1000, 0, 1, duration * 1000);
        value = startValue + v * (endValue - startValue);
        
        [valueArray addObject:@(value)];
        
        progress += increment;
    }
    
    return [NSArray arrayWithArray:valueArray];
}

+ (NSArray*) createColorArrayFromRed:(NSArray*)redValues green:(NSArray*)greenValues blue:(NSArray*)blueValues alpha:(NSArray*)alphaValues {
    NSAssert(redValues.count == blueValues.count && redValues.count == greenValues.count && redValues.count == alphaValues.count, @"array must have arrays of equal size");
    
    NSUInteger numberOfColors = redValues.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfColors];
    UIColor *value;
    
    for (NSInteger i = 1; i < numberOfColors; i++) {
        value = [UIColor colorWithRed:[[redValues objectAtIndex:i] floatValue]
                                green:[[greenValues objectAtIndex:i] floatValue]
                                 blue:[[blueValues objectAtIndex:i] floatValue]
                                alpha:[[alphaValues objectAtIndex:i] floatValue]];
        [values addObject:(id)value.CGColor];
    }
    return values;
}

+ (NSArray*) createRectArrayFromXValues:(NSArray*)xValues yValues:(NSArray*)yValues widths:(NSArray*)widths heights:(NSArray*)heights {
    NSAssert(xValues.count == yValues.count && xValues.count == widths.count && xValues.count == heights.count, @"array must have arrays of equal size");
    
    NSUInteger numberOfRects = xValues.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfRects];
    CGRect value;
    
    for (NSInteger i = 1; i < numberOfRects; i++) {
        value = CGRectMake(
                           [[xValues objectAtIndex:i] floatValue],
                           [[yValues objectAtIndex:i] floatValue],
                           [[widths objectAtIndex:i] floatValue],
                           [[heights objectAtIndex:i] floatValue]
                           );
        [values addObject:[NSValue valueWithCGRect:value]];
    }
    return values;
}

+ (NSArray*) createTransformArrayFromM11:(NSArray*)m11 M12:(NSArray*)m12 M13:(NSArray*)m13 M14:(NSArray*)m14
                                     M21:(NSArray*)m21 M22:(NSArray*)m22 M23:(NSArray*)m23 M24:(NSArray*)m24
                                     M31:(NSArray*)m31 M32:(NSArray*)m32 M33:(NSArray*)m33 M34:(NSArray*)m34
                                     M41:(NSArray*)m41 M42:(NSArray*)m42 M43:(NSArray*)m43 M44:(NSArray*)m44 {
    NSUInteger numberOfTransforms = m11.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfTransforms];
    CATransform3D value;
    
    for (NSInteger i = 1; i < numberOfTransforms; i++) {
        value = CATransform3DIdentity;
        value.m11 = [[m11 objectAtIndex:i] floatValue];
        value.m12 = [[m12 objectAtIndex:i] floatValue];
        value.m13 = [[m13 objectAtIndex:i] floatValue];
        value.m14 = [[m14 objectAtIndex:i] floatValue];
        
        value.m21 = [[m21 objectAtIndex:i] floatValue];
        value.m22 = [[m22 objectAtIndex:i] floatValue];
        value.m23 = [[m23 objectAtIndex:i] floatValue];
        value.m24 = [[m24 objectAtIndex:i] floatValue];
        
        value.m31 = [[m31 objectAtIndex:i] floatValue];
        value.m32 = [[m32 objectAtIndex:i] floatValue];
        value.m33 = [[m33 objectAtIndex:i] floatValue];
        value.m44 = [[m34 objectAtIndex:i] floatValue];
        
        value.m41 = [[m41 objectAtIndex:i] floatValue];
        value.m42 = [[m42 objectAtIndex:i] floatValue];
        value.m43 = [[m43 objectAtIndex:i] floatValue];
        value.m44 = [[m44 objectAtIndex:i] floatValue];
        
        [values addObject:[NSValue valueWithCATransform3D:value]];
    }
    return values;
}

static CGPathRef createPathFromXYValues(NSArray *xValues, NSArray *yValues) {
    NSUInteger numberOfPoints = xValues.count;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint value;
    value = CGPointMake([[xValues objectAtIndex:0] floatValue], [[yValues objectAtIndex:0] floatValue]);
    CGPathMoveToPoint(path, NULL, value.x, value.y);
    
    for (NSInteger i = 1; i < numberOfPoints; i++) {
        value = CGPointMake([[xValues objectAtIndex:i] floatValue], [[yValues objectAtIndex:i] floatValue]);
        CGPathAddLineToPoint(path, NULL, value.x, value.y);
    }
    return path;
}

+ (void)addKeyframeAnimationFunctionBlocks:(NSMutableDictionary *)easingFuncBlocks {
    NSBKeyframeAnimationFunctionBlock funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInSine(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInSine"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutSine(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutSine"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutSine(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutSine"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInQuad(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeIn"];
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInQuad"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutQuad(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOut"];
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutQuad"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutQuad(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOut"];
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutQuad"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInCubic(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInCubic"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutCubic(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutCubic"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutCubic(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutCubic"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInQuart(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInQuart"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutQuart(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutQuart"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutQuart(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutQuart"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInQuint(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInQuint"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutQuint(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutQuint"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutQuint(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutQuint"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInExpo(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInExpo"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutExpo(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutExpo"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutExpo(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutExpo"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInCirc(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInCirc"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutCirc(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutCirc"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutCirc(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutCirc"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInBack(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInBack"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutBack(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutBack"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutBack(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutBack"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInElastic(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInElastic"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutElastic(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutElastic"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutElastic(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutElastic"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInBounce(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInBounce"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutBounce(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeOutBounce"];
    
    funcBlock = ^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutBounce(t, b, c, d);
    };
    [easingFuncBlocks setValue:funcBlock forKey:@"easeInOutBounce"];
}

@end
