//
//  YWGroupAnimConfig.m
//  YWAnimationDemo
//
//  Created by jin tang on 2016/12/18.
//  Copyright © 2016年 jin tang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "YWGroupAnimConfig.h"
#import "YWGroupAnimGifInfo.h"
#import "YWGroupAnimBean.h"
#import "YWGroupAnimAlphaBean.h"
#import "YWGroupAnimScaleBean.h"
#import "YWGroupAnimTranslateBean.h"
#import "YWGroupAnimRotateBean.h"
#import "MJExtension.h"

@interface YWGroupAnimConfig () <NSXMLParserDelegate>

@property (nonatomic, copy) ParseCompletionBlock completionBlock;
@property (nonatomic, strong) NSMutableArray<YWGroupAnimGifInfo *> *gifAnimInfos;
@property (nonatomic, strong) NSMutableArray<YWGroupAnimBean *> *groupAnimBeans;

@end

@implementation YWGroupAnimConfig

SYNTHESIZE_SINGLETON_FOR_CLASS(YWGroupAnimConfig);

#pragma mark - init cycle
-(void)xmlConfigParser:(ParseCompletionBlock)parseCompletionBlock {
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

- (void)clearData {
    _gifAnimDuration = 0.0f;
    _animBean = nil;
    
    [_gifAnimImages removeAllObjects];
    [_gifAnimaKeyTimes removeAllObjects];
    [_gifAnimInfos removeAllObjects];
    [_groupAnimBeans removeAllObjects];
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    [self clearData];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_completionBlock) {
        [self.groupAnimBeans sortUsingComparator:^NSComparisonResult(YWGroupAnimBean * _Nonnull left, YWGroupAnimBean *  _Nonnull right) {
            if (left.beginTime > right.beginTime) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionBlock(YES);
        });
    };
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if(parseError) {
        if (_completionBlock) {
            [self clearData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _completionBlock(NO);
            });
        };
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"image"]) {
        YWGroupAnimGifInfo *info = [YWGroupAnimGifInfo mj_objectWithKeyValues:attributeDict];
        [self.gifAnimInfos addObject:info];
    } else if ([elementName isEqualToString:@"animation"]) {
        _animBean = [YWGroupAnimBean mj_objectWithKeyValues:attributeDict];
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
        _gifAnimImages = [[NSMutableArray alloc] init];
        _gifAnimaKeyTimes = [[NSMutableArray alloc] init];
        
        for (YWGroupAnimGifInfo *info in self.gifAnimInfos) {
            _gifAnimDuration += info.duration;
        }
        
        for (YWGroupAnimGifInfo *info in self.gifAnimInfos) {
            //UIImage *image = [UIImage imageWithContentsOfFile:@""];
            UIImage *image = [UIImage imageNamed:info.imageName];
            if (image) {
                [_gifAnimImages addObject:(__bridge id _Nonnull)image.CGImage];
                [_gifAnimaKeyTimes addObject:@(info.duration/_gifAnimDuration)];
            }
        }
        [self.gifAnimInfos removeAllObjects];
    }
}

- (void)addAnimBean:(YWGroupAnimBean *)animBean {
    float tmpDuration = animBean.beginTime + animBean.duration;
    _animBean.duration = (tmpDuration > _animBean.duration ? tmpDuration : _animBean.duration);
    
    [self.groupAnimBeans addObject:animBean];
}

- (NSMutableArray<YWGroupAnimGifInfo *> *)gifAnimInfos {
    if (!_gifAnimInfos) {
        _gifAnimInfos = [[NSMutableArray<YWGroupAnimGifInfo *> alloc] init];
    }
    return _gifAnimInfos;
}

- (NSMutableArray<YWGroupAnimBean *> *)groupAnimBeans {
    if (!_groupAnimBeans) {
        _groupAnimBeans = [[NSMutableArray<YWGroupAnimBean *> alloc] init];
    }
    return _groupAnimBeans;
}

@end
