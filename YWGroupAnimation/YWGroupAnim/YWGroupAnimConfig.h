//
//  YWGroupAnimConfig.h
//  YWAnimationDemo
//
//  Created by jin tang on 2016/12/18.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonInstance.h"

@class YWGroupAnimGifInfo;
@class YWGroupAnimBean;

typedef void(^ParseCompletionBlock)(BOOL isSucc);

@interface YWGroupAnimConfig : NSObject

DECLARE_SINGLETON_FOR_CLASS(YWGroupAnimConfig);

@property (nonatomic, assign, readonly) float gifAnimDuration;
@property (nonatomic, strong, readonly) NSMutableArray *gifAnimImages;
@property (nonatomic, strong, readonly) NSMutableArray *gifAnimaKeyTimes;

@property (nonatomic, strong, readonly) YWGroupAnimBean *animBean;
@property (nonatomic, strong, readonly) NSMutableArray<YWGroupAnimBean *> *groupAnimBeans;

-(void)xmlConfigParser:(ParseCompletionBlock)parseCompletionBlock;

@end
