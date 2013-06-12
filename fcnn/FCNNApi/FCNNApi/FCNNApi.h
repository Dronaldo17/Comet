//
//  FCNNApi.h
//  FCNNApi
//
//  Created by doujingxuan on 13-4-1.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpRequest.h"
#import "ASIFormDataRequest.h"
#import "ApiParamsMarcos.h"

@interface FCNNApi : NSObject <ASIHTTPRequestDelegate>
{
    ASIHTTPRequest * _request;
    ASIFormDataRequest * _postRequest;
}
@property (nonatomic,retain)NSString * apiName;
@property (nonatomic,retain)NSMutableDictionary * param;
@property (nonatomic,retain)NSMutableDictionary * photoDict;
@property (nonatomic,retain)ASIHTTPRequest * request;
-(id)initWithApiName:(NSString*)apiNames WithParamInfo:(NSMutableDictionary*)params;
-(void)startFCNNRequest;

-(id)initWithApiName:(NSString*)apiNames PostPhotoDict:(NSMutableDictionary*)photoDictUserInfo;
-(void)startFCNNPhotoUpload;
@end
