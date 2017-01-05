//
//  YWGroupAnimBean.m
//  YWAnimationDemo
//
//  Created by jin tang on 2016/12/18.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YWGroupAnimBean.h"
#import "MJExtension.h"

@implementation YWGroupAnimBean

- (instancetype)init {
    if (self = [super init]) {
        _beginTime = 0.0f;
        _duration = 0.0f;
        _repeatCount = 1;
        
        _autoreverses = NO;
        _removedOnCompletion = YES;
        _fillMode = kCAFillModeForwards;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"autoreverses" : @"repeatMode"};
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"removedOnCompletion"];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"beginTime"] || [property.name isEqualToString:@"duration"]) {
        return @([oldValue floatValue]/1000);
    }
    
    if ([property.name isEqualToString:@"autoreverses"]) {
        return @([oldValue isEqualToString:@"reverse"]);
    }
    
    if ([property.name isEqualToString:@"fillMode"]) {
        if ([oldValue isEqualToString:@"forwards"] || [oldValue isEqualToString:@"backwards"] || [oldValue isEqualToString:@"both"]) {
            _removedOnCompletion = NO;
            return oldValue;
        }
    }
    return oldValue;
}

- (float)repeatCount {
    if (_repeatCount < 0.0f) {
        return MAXFLOAT;
    }
    if (0.0f == _repeatCount) {
        return 1;
    }
    return _repeatCount ;
}

@end
