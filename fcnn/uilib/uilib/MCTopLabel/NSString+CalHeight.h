//
//  NSString+CalHeight.h
//  CircleDetailDemo
//
//  Created by doujingxuan on 13-1-29.
//  Copyright (c) 2013年 XLHT Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface NSString (CalHeight)
-(CGSize)calNSStringHeightWithFont:(UIFont*)font width:(CGFloat)width;
@end
