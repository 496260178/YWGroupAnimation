//
//  YWGroupAnimInfo.h
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWGroupAnimGifInfo;
@class YWGroupAnimBean;

@interface YWGroupAnimInfo : NSObject

@property (nonatomic, assign) float gifAnimDuration;

@property (nonatomic, strong) NSMutableArray *gifAnimImages;
@property (nonatomic, strong) NSMutableArray *gifAnimaKeyTimes;

@property (nonatomic, strong) YWGroupAnimBean *animBean;
@property (nonatomic, strong) NSMutableArray<YWGroupAnimBean *> *groupAnimBeans;

@end
