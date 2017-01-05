//
//  YWGroupAnimBean.h
//  YWAnimationDemo
//
//  Created by jin tang on 2016/12/18.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Study)();

@interface YWGroupAnimBean : NSObject

@property (nonatomic, copy) Study study;

@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign) CFTimeInterval duration;

@property (nonatomic, assign) float repeatCount;
@property (nonatomic, assign) BOOL autoreverses;
@property (nonatomic, assign, getter=isRemovedOnCompletion) BOOL removedOnCompletion;

@property (nonatomic, copy) NSString *fillMode;
@property (nonatomic, copy) NSString *easingFuction;

@end
