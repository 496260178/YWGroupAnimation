//
//  YWGroupAnimInfo.m
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import "YWGroupAnimInfo.h"
#import "YWGroupAnimBean.h"

@implementation YWGroupAnimInfo

- (NSMutableArray *)gifAnimImages {
    if (!_gifAnimImages) {
        _gifAnimImages = [[NSMutableArray alloc] init];
    }
    return _gifAnimImages;
}

- (NSMutableArray *)gifAnimaKeyTimes {
    if (!_gifAnimaKeyTimes) {
        _gifAnimaKeyTimes = [[NSMutableArray alloc] init];
    }
    return _gifAnimaKeyTimes;
}

- (YWGroupAnimBean *)animBean {
    if (!_animBean) {
        _animBean = [[YWGroupAnimBean alloc] init];
    }
    return _animBean;
}

- (NSMutableArray<YWGroupAnimBean *> *)groupAnimBeans {
    if (!_groupAnimBeans) {
        _groupAnimBeans = [[NSMutableArray<YWGroupAnimBean *> alloc] init];
    }
    return _groupAnimBeans;
}

@end
