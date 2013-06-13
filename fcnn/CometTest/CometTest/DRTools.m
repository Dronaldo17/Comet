//
//  DRTools.m
//  CometTest
//
//  Created by doujingxuan on 13-6-12.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import "DRTools.h"

@implementation DRTools
+(id)getValueFromNSUserDefaultsByKey:(NSString*)key
{
    if (key) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        id obj = [defaults objectForKey:key];
        return obj;
    }
    return nil;
}
+(void)syncNSUserDeafaultsByKey:(NSString*)key withValue:(id)value
{
    if (key && value) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
        [defaults  synchronize];
    }
}
+(void)tapAlertWithMessage:(NSString*)message
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
}
+(NSString*)stringFromADate:(NSDate*)date withFormat:(NSString*)format;
{
    if (isNull(date) || isEmpty(format)) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return strDate;
}
@end
