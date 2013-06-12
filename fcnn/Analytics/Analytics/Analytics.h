//
//  Analytics.h
//  Analytics
//
//  Created by Ronaldo on 12-11-30.
//  Copyright (c) 2012年 Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"
/* 此类是统计用的：
 现在我只加入了友盟统计，可以堆机器类型的统计，crash报告，还可以统计我们的字段（需要到网页端手动添加），
 还有一个是flurry，国外的一款比较好的，这个统计字段不需要到网页端添加，这个的好处是可以导出excal表格，
 目前1.2,我们只先加入umeng统计，后边我们会加入flurry
 */
@interface Analytics : NSObject
+ (void) doInit;
+ (void) doDestroy;
+ (id) defaultAnalytics;
-(void)addAnalytics:(NSString*)analyticsString;
-(void)doInitAnalyticsAppKey;
@end
