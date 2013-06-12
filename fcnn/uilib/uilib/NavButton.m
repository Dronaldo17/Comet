//
//  NavButton.m
//  uilib
//
//  Created by doujingxuan on 13-3-10.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import "NavButton.h"

@implementation NavButton
+ (UIButton *)createNavButtonWithTitle:(NSString *)title withHorPadding:(CGFloat)padding
{
    NSLog(@"title is %@",title);
    CGSize titleSize = CGSizeMake(45, 32);
    if (title && ![@"" isEqualToString:title]) {
        titleSize = [title sizeWithFont:[UIFont systemFontOfSize:14.0]];
        titleSize.width += 2 * padding;
        titleSize.height = 32;
    }
    UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)] autorelease];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    UIImage *btnImage = [UIImage imageNamed:@"Nav_Button_1"];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    return btn;
}
+ (UIButton *)createPopButton:(NSString*)title withHorPadding:(CGFloat)padding
{
    title = @" 返回";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 48, 30);
     [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *btnImage = [UIImage imageNamed:@"Nav_Back"];
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    return btn;
}
+ (void)addNavBackGroundView:(UINavigationController*)nav
{
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_Background_1"] forBarMetrics:UIBarMetricsDefault];
    
}
+(UIButton*)createPopButtonWithImage:(NSString*)imageName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    return btn;
}
@end
