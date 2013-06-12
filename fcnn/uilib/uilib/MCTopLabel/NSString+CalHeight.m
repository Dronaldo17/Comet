//
//  NSString+CalHeight.m
//  CircleDetailDemo
//
//  Created by doujingxuan on 13-1-29.
//  Copyright (c) 2013年 XLHT Inc. All rights reserved.
//

#import "NSString+CalHeight.h"

@implementation NSString (CalHeight)
-(CGSize)calNSStringHeightWithFont:(UIFont*)font width:(CGFloat)width
{
    CGSize size = CGSizeMake(width,MAXFLOAT);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize;

}
@end
