//
//  YWGroupAnimConfig.m
//  YWGroupAnimation
//
//  Created by JinTang on 2017/1/5.
//  Copyright © 2017年 jin tang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "YWGroupAnimConfig.h"
#import "YWGroupAnimGifInfo.h"
#import "YWGroupAnimInfo.h"
#import "YWGroupAnimBean.h"
#import "YWGroupAnimAlphaBean.h"
#import "YWGroupAnimScaleBean.h"
#import "YWGroupAnimTranslateBean.h"
#import "YWGroupAnimRotateBean.h"
#import "MJExtension.h"

@interface YWGroupAnimConfig () <NSXMLParserDelegate>

@property (nonatomic, copy) ParseCompletionBlock completionBlock;
@property (nonatomic, strong) YWGroupAnimInfo *animInfo;
@property (nonatomic, strong) NSMutableArray<YWGroupAnimGifInfo *> *gifAnimInfos;

@end

@implementation YWGroupAnimConfig

#pragma mark - life cycle
- (void)xmlConfigParserWithParseCompletionBlock:(ParseCompletionBlock)parseCompletionBlock {
    [self clearData];
    _completionBlock = parseCompletionBlock;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        xmlParser.delegate = self;
        [xmlParser parse];
    });
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_completionBlock) {
        [self.animInfo.groupAnimBeans sortUsingComparator:^NSComparisonResult(YWGroupAnimBean * _Nonnull left, YWGroupAnimBean *  _Nonnull right) {
            if (left.beginTime > right.beginTime) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionBlock(YES, self.animInfo);
        });
    };
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if(parseError) {
        if (_completionBlock) {
            [self clearData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _completionBlock(YES, nil);
            });
        };
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"image"]) {
        YWGroupAnimGifInfo *info = [YWGroupAnimGifInfo mj_objectWithKeyValues:attributeDict];
        [self.gifAnimInfos addObject:info];
    } else if ([elementName isEqualToString:@"animation"]) {
        self.animInfo.animBean = [YWGroupAnimBean mj_objectWithKeyValues:attributeDict];
    } else if ([elementName isEqualToString:@"alpha"]) {
        YWGroupAnimAlphaBean *animBean = [YWGroupAnimAlphaBean mj_objectWithKeyValues:attributeDict];
        [self addAnimBean:animBean];
    } else if ([elementName isEqualToString:@"scale"]) {
        YWGroupAnimScaleBean *animBean = [YWGroupAnimScaleBean mj_objectWithKeyValues:attributeDict];
        [self addAnimBean:animBean];
    } else if ([elementName isEqualToString:@"translate"]) {
        YWGroupAnimTranslateBean *animBean = [YWGroupAnimTranslateBean mj_objectWithKeyValues:attributeDict];
        animBean.fromXDelta *= 0.5f;
        animBean.toXDelta   *= 0.5f;
        animBean.fromYDelta *= 0.5f;
        animBean.toYDelta   *= 0.5f;
        [self addAnimBean:animBean];
    } else if ([elementName isEqualToString:@"rotate"]) {
        YWGroupAnimRotateBean *animBean = [YWGroupAnimRotateBean mj_objectWithKeyValues:attributeDict];
        [self addAnimBean:animBean];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    if ([elementName isEqualToString:@"images"]) {
        for (YWGroupAnimGifInfo *info in self.gifAnimInfos) {
            self.animInfo.gifAnimDuration += info.duration;
        }
        
        for (YWGroupAnimGifInfo *info in self.gifAnimInfos) {
            UIImage *image = [UIImage imageNamed:info.imageName];
            if (image) {
                [self.animInfo.gifAnimImages addObject:(__bridge id _Nonnull)image.CGImage];
                [self.animInfo.gifAnimaKeyTimes addObject:@(info.duration/self.animInfo.gifAnimDuration)];
            }
        }
        [self.gifAnimInfos removeAllObjects];
    }
}

#pragma mark - private methods
- (void)addAnimBean:(YWGroupAnimBean *)animBean {
    float tmpDuration = animBean.beginTime + animBean.duration;
    float currentDuration = self.animInfo.animBean.duration;
    
    self.animInfo.animBean.duration = (tmpDuration > currentDuration ? tmpDuration : currentDuration);
    [self.animInfo.groupAnimBeans addObject:animBean];
}

- (void)clearData {
    _animInfo = nil;
    [_gifAnimInfos removeAllObjects];
}

#pragma mark - getters and setters
- (NSMutableArray<YWGroupAnimGifInfo *> *)gifAnimInfos {
    if (!_gifAnimInfos) {
        _gifAnimInfos = [[NSMutableArray<YWGroupAnimGifInfo *> alloc] init];
    }
    return _gifAnimInfos;
}

- (YWGroupAnimInfo *)animInfo {
    if (!_animInfo) {
        _animInfo = [[YWGroupAnimInfo alloc] init];
    }
    return _animInfo;
}

@end
