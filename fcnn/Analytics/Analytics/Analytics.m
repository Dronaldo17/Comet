//
//  Analytics.m
//  Analytics
//
//  Created by Ronaldo on 12-11-30.
//  Copyright (c) 2012年 Ronaldo. All rights reserved.
//

#import "Analytics.h"
#define CHANNELID @"Develop"
//#define CHANNELID @"91 assistant"
//#define CHANNELID @"App Store"

static  Analytics * _analytics = nil;
@implementation Analytics
/*Ronaldo  添加数据统计对象的初始化方法*/
+ (void) doInit {
    
    if (nil == _analytics) {
        _analytics = [[Analytics alloc] init];
    }
}
/*Ronaldo 对数据统计对象释放内存*/
+ (void) doDestroy {
    [_analytics release];
}

/*Ronaldo   添加数据统计对象的初始化方法如果存在直接调用不存在创建*/
+ (id) defaultAnalytics {
    @synchronized(self){
        if (nil == _analytics) {
            [Analytics doInit];
        }
        
        return _analytics;
    }
    
    return nil;
}
/*Ronaldo    统计数据时调用的方法*/
-(void)addAnalytics:(NSString*)analyticsString{
    [MobClick event:analyticsString];
}
/*Ronaldo    对umeng和flurry初始化*/
-(void)doInitAnalyticsAppKey{
    //    NSString * flurryAppkey = [NSString stringWithCString:"D49LPN8MF34IWYLS7RTR"
    //                                                 encoding:NSUTF8StringEncoding];
    //    [FlurryAnalytics startSession:flurryAppkey];
    /*stary umeng trace log*/
    NSString * umengAppkey = [NSString stringWithCString:"513c31915270155822000004"
                                                encoding:NSUTF8StringEncoding];
    [MobClick startWithAppkey:umengAppkey reportPolicy:REALTIME channelId:CHANNELID];
}
@end
