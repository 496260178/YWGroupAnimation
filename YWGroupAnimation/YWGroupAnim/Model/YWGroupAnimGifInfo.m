//
//  YWGroupAnimGifInfo.m
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
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
