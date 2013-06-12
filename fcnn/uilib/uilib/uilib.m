//
//  uilib.m
//  uilib
//
//  Created by Ronaldo on 13-3-10.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import "uilib.h"

@implementation uilib
NSObject *loadObjectFromNibFileSimple(NSString *xibName) {
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] objectAtIndex:0];
}

@end
