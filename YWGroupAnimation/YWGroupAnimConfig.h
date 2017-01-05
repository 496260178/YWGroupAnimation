//
//  YWGroupAnimConfig.h
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWGroupAnimInfo;

typedef void(^ParseCompletionBlock)(BOOL isSucc, YWGroupAnimInfo *info);

@interface YWGroupAnimConfig : NSObject

- (void)xmlConfigParserWithParseCompletionBlock:(ParseCompletionBlock)parseCompletionBlock;

@end
