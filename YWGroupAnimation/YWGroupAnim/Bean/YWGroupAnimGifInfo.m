//
//  YWGroupAnimGifInfo.m
//  YWAnimationDemo
//
//  Created by JinTang on 2016/12/20.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import "YWGroupAnimGifInfo.h"
#import "MJExtension.h"

@implementation YWGroupAnimGifInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"imageName" : @"src"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"duration"]) {
        return @([oldValue floatValue]/1000);
    }
    return oldValue;
}

@end
