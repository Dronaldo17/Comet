//
//  Parse.h
//  Parse
//
//  Created by Ronaldo on 13-3-9.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiLogger.h"
#import "DebugLog.h"
#import "common.h"
#import "ZipArchive.h"
#import "HSMessageObserver.h"
#import "IHSMessageObserver.h"
#import "RegexKitLite.h"
#import "AbstractSystemDataUpdater.h"
#import "SystemDataUpdater.h"

@interface Parse : NSObject
+(NSString* ) convertBirthdayToConstellation:(NSDate *) birthday;
@end
