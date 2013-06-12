//
//  FCNNApi.m
//  FCNNApi
//
//  Created by doujingxuan on 13-4-1.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import "FCNNApi.h"
#import "Parse.h"
#import "SBJsonWriter.h"
#import "NSObject+SBJson.h"

#define URLSTRING @"http://118.145.0.70:8099/openapi"
#define URLPHOTO_STRING @"http://118.145.0.70:8099/img"
#define CONTENT_TYPE_Value @"Content-Type"
#define CONTENT_TYPE @"application/json"

/**Author:Ronaldo Description:标志请求是否成功，失败为0,请求成功并且返回数据正确为1,请求成功但返回数据错误为2*/
#define REQUEST_SUCCESS_TAG 1
#define REQUEST_FAILED_TAG 0
#define REQUEST_SUCCESS_DATAERROR_TAG 2

static NSString* photoFile = nil;

@implementation FCNNApi
@synthesize apiName,param,photoDict,request = _request;
- (void)dealloc
{
    self.apiName = nil;
    self.param = nil;
    self.photoDict = nil;
    if (_request) {
        [_request  release];
         _request = nil;
    }
    if(_postRequest){
        [_postRequest release];
        _postRequest = nil;
    }
    [super dealloc];
}
#pragma mark
#pragma CustomRequest
-(id)initWithApiName:(NSString *)apiNames WithParamInfo:(NSMutableDictionary *)params
{
    self = [super init];
    if (self) {
        if (isEmpty(apiNames) || isNull(params)) {
            return self;
        }
        self.apiName = apiNames;
        self.param = params;
    }
    return self;
}
-(void)startFCNNRequest
{
    /**Author:Ronaldo Description:组合需要的数据传给服务器*/
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc]init];
     NSString * paramString = [jsonWriter stringWithObject:self.param];
    NSLog(@"paramString is %@",paramString);
    [jsonWriter release];
    
    NSData * paramData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    /**Author:Ronaldo Description:创建链接*/
    NSString * urlString = URLSTRING;
    NSURL * url = [NSURL URLWithString:urlString];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    
    [request addRequestHeader:CONTENT_TYPE value:CONTENT_TYPE_Value];
    [request appendPostData:paramData];
    
    /**Author:Ronaldo Description:利用asi的block 成功发送成功通知  失败发送失败通知  通知名字相同 但是 paramLong  这个参数*/
    [request setCompletionBlock:^{
        NSString * responseString = [request  responseString];
        apiLogDebug(@"responseString is %@",responseString);
        NSMutableDictionary * dict = [responseString JSONValue];
        apiLogDebug(@"dict is %@",dict);
        [self fcnnApiRequestSuccess:dict];
    }];
    [request setFailedBlock:^{
        [self fcnnApiRequestFailed];
    }];
    [request startAsynchronous];
}
#pragma mark
#pragma photoRequest
-(id)initWithApiName:(NSString*)apiNames PostPhotoDict:(NSMutableDictionary*)photoDictUserInfo
{
    self = [super init];
    if (self) {
        if (isNull(photoDictUserInfo) || isEmpty(apiNames)) {
            return self;
        }
        self.photoDict = photoDictUserInfo;
        self.apiName = apiNames;
    }
    return self;
}
-(void)fcnnApiRequestSuccess:(NSMutableDictionary*)dict
{
    id backNumber = dict[F_HEADER][F_RESULT];
    if ( nil == backNumber) {
        return ;
    }
    int number;
    if ([backNumber isKindOfClass:[NSString class]]) {
        number = [backNumber intValue];
    }
    if ([backNumber isKindOfClass:[NSNumber class]]) {
        number = [backNumber intValue];
    }
    if ( 1 == number) {
        [[HSMessageObserver defaultObserver] sendMessage:self.apiName  paramObject:dict paramLong:REQUEST_SUCCESS_TAG];
    }
    else{
        NSString * waringString = [self parseErrorCodeToInfoString:number];
        [[HSMessageObserver defaultObserver] sendMessage:self.apiName  paramObject:waringString paramLong:REQUEST_SUCCESS_DATAERROR_TAG];
    }
}
-(void)fcnnApiRequestFailed
{
     [[HSMessageObserver defaultObserver] sendMessage:self.apiName paramObject:nil paramLong:REQUEST_FAILED_TAG];
}
-(void)fcnnUploadImageSuccess:(NSDictionary *)requestString
{
    [[HSMessageObserver defaultObserver] sendMessage:self.apiName  paramObject:requestString paramLong:REQUEST_SUCCESS_TAG];
}
-(void)fcnnUploadImageFailed
{
    [[HSMessageObserver defaultObserver] sendMessage:self.apiName paramObject:nil paramLong:REQUEST_FAILED_TAG];
}
-(void)startFCNNPhotoUpload
{
    /**Author:Ronaldo Description:创建链接*/
    NSString * urlString = [NSString stringWithFormat:@"%@?src=1&type=%@&token=%@",URLPHOTO_STRING,self.photoDict[F_TYPE],self.photoDict[F_TOKEN]];
    NSURL * url = [NSURL URLWithString:urlString];
   // NSLog(@"self.photoDict is %@",self.photoDict);

    _postRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [_postRequest setPostFormat:ASIMultipartFormDataPostFormat];
    _postRequest.timeOutSeconds = 30.f;
    NSString* homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    photoFile = [[homePath stringByAppendingPathComponent:@"tmpPhoto.jpg"] retain];
    
    [self.photoDict[F_UPFILE] writeToFile:photoFile atomically:YES];
    
   [_postRequest setFile:photoFile forKey:F_UPFILE];
    
    [_postRequest setCompletionBlock:^{
        apiLogDebug(@"上传成功");
        NSString * responseString = [_postRequest  responseString];
        FCNNDEBUG(@"上传图片返回的数据responseString : %@",responseString);
        NSMutableDictionary * dict = [responseString JSONValue];
        if (isNull(dict)) {
            [[HSMessageObserver defaultObserver] sendMessage:self.apiName  paramObject:nil paramLong:REQUEST_SUCCESS_DATAERROR_TAG];
            return ;
        }
        else{
            FCNNDEBUG(@"上传图片返回的数据: %@",dict);
            [self fcnnUploadImageSuccess:dict];
     }
        }];
    [_postRequest setFailedBlock:^{
        //apiLogDebug(@"上传失败");
        FCNNDEBUG(@"错误信息： %@",_postRequest.error.userInfo);
        [self fcnnUploadImageFailed];
    }];
    [_postRequest startAsynchronous];
}
-(NSString*)parseErrorCodeToInfoString:(int)errorNumber
{
    NSString * warnInfo = nil;
    if (-1 == errorNumber) {
        warnInfo = @"解析错误";
    }
    else if (-2 == errorNumber){
        warnInfo = @"request_type无效";
    }
    else if (-3 == errorNumber){
        warnInfo = @"程序执行异常无效";
    }
    else if (-4 == errorNumber){
        warnInfo = @"用户ID为空";
    }
    else if (-6 == errorNumber){
        warnInfo = @"用户不存在";
    }
    else if (-7 == errorNumber){
        warnInfo = @"好友ID不存在";
    }
    else if (-8 == errorNumber){
        warnInfo = @"好友信息不存在";
    }
    else if (-9 == errorNumber){
        warnInfo = @"初次联系人不能看信";
    }
    else if (-10 == errorNumber){
        warnInfo = @"商品id错误";
    }else if (-11 == errorNumber){
        warnInfo = @"支付类型错误";
    }
    else if (-12 == errorNumber){
        warnInfo = @"产品价格错误";
    }else if (-13 == errorNumber){
        warnInfo = @"领取类型错误";
    }
    else if (-14 == errorNumber){
        warnInfo = @"充值类型错误";
    }
    else if (-15 == errorNumber){
        warnInfo = @"旧密码错误";
    }
    else if (-16 == errorNumber){
        warnInfo = @"新密码格式错误";
    }
    else if (-17 == errorNumber){
        warnInfo = @"订单ID错误";
    }
    else if (-18 == errorNumber){
        warnInfo = @"签名错误";
    }
    else if (-19 == errorNumber){
        warnInfo = @"支付结果错误";
    }
    else if (-20 == errorNumber){
        warnInfo = @"账户余额不足";
    }
    else if (-21 == errorNumber){
        warnInfo = @"余额错误";
    }
    else if (-22 == errorNumber){
        warnInfo = @"照片数量小于5张";
    }
    else if (-23 == errorNumber){
        warnInfo = @"照片不存在";
    }
    else if (-24 == errorNumber){
        warnInfo = @"用户中文名为空";
    }
    else if (-25 == errorNumber){
        warnInfo = @"免费次数用完,去打五分";
    }
    else if (-26 == errorNumber){
        warnInfo = @"打完五分又摇完";
    }
    else if (-27 == errorNumber){
        warnInfo = @"验证异常";
    }
    else if (-28 == errorNumber){
        warnInfo = @"库中无此人信息";
    }
    else if (-29 == errorNumber){
        warnInfo = @"参数错误";
    }
    else if (-30 == errorNumber){
        warnInfo = @"性别异常";
    }
    else if (-31 == errorNumber){
        warnInfo = @"标题内容为空";
    }
    else if (-32 == errorNumber){
        warnInfo = @"发帖ID错误";
    }
    else if (-33 == errorNumber){
        warnInfo = @"权限不足";
    }
    else if (-34 == errorNumber){
        warnInfo = @"博客ID错误";
    }
    else if (-35 == errorNumber){
        warnInfo = @"记录已删除";
    }
    else if (-36 == errorNumber){
        warnInfo = @"记录未审核";
    }
    else if (-37 == errorNumber){
        warnInfo = @"密码错误";
    }
    else if (-38 == errorNumber){
        warnInfo = @"手机号错误";
    }
    else if (-39 == errorNumber){
        warnInfo = @"参数ID错误";
    }
    else if (-40 == errorNumber){
        warnInfo = @"所在地ID错误";
    }
    else if (-41 == errorNumber){
        warnInfo = @"生日错误";
    }
    else if (-42 == errorNumber){
        warnInfo = @"学历错误";
    }
    else if (-43 == errorNumber){
        warnInfo = @"内在错误";
    }
    else if (-44 == errorNumber){
        warnInfo = @"外在错误";
    }
    else if (-45 == errorNumber){
        warnInfo = @"喜欢错误";
    }
    else if (-46 == errorNumber){
        warnInfo = @"讨厌错误";
    }
    else if (-47 == errorNumber){
        warnInfo = @"其他错误";
    }
    else if (-48 == errorNumber){
        warnInfo = @"背景图类型错误";
    }
    else if (-49 == errorNumber){
        warnInfo = @"已经收藏过";
    }
    else if (-50 == errorNumber){
        warnInfo = @"赠送失败";
    }
    else if (-51 == errorNumber){
        warnInfo = @"验证码错误";
    }
    else if (-52 == errorNumber){
        warnInfo = @"手机号已被其他会员绑定";
    }
    else if (-53 == errorNumber){
        warnInfo = @"EMAIL错误";
    }
    else if (-54 == errorNumber){
        warnInfo = @"来源错误";
    }
    else if (-55 == errorNumber){
        warnInfo = @"邮箱已注册";
    }
    else if (-56 == errorNumber){
        warnInfo = @"手机已注册";
    }
    else if (-57 == errorNumber){
        warnInfo = @"今天下行短信超过规定条数";
    }
    else if (-58 == errorNumber){
        warnInfo = @"已经验证了手机号";
    }
    else if (-59 == errorNumber){
        warnInfo = @"邮箱尚未注册";
    }
    else if (-60 == errorNumber){
        warnInfo = @"正在与其他会员聊天";
    }
    else if (-61 == errorNumber){
        warnInfo = @"对方已经断开了当前聊天";
    }
    else if (-62 == errorNumber){
        warnInfo = @"对方拒绝与你聊天";
    }
    else if (-63 == errorNumber){
        warnInfo = @"用户不在线";
    }
    else if (-64 == errorNumber){
        warnInfo = @"性别相同";
    }
    else if (-65 == errorNumber){
        warnInfo = @"ACTIONID错误";
    }
    else if (-66 == errorNumber){
        warnInfo = @"从来没联系过";
    }
    else if (-67 == errorNumber){
        warnInfo = @"回复ID错误";
    }
    else if (-68 == errorNumber){
        warnInfo = @"EMAIL未验证";
    }
    else if (-69 == errorNumber){
        warnInfo = @"地址为空";
    }
    else if (-70 == errorNumber){
        warnInfo = @"支付类型为空";
    }
    else if (-71 == errorNumber){
        warnInfo = @"道具ID错误";
    }
    else if (-72 == errorNumber){
        warnInfo = @"我的道具ID错误";
    }
    else if (-73 == errorNumber){
        warnInfo = @"我的道具已经被使用";
    }
    else if (-74 == errorNumber){
        warnInfo = @"产品ID错误";
    }
    else if (-75 == errorNumber){
        warnInfo = @"道具已过期";
    }
    else if (-76 == errorNumber){
        warnInfo = @"道具不能解除";
    }
    else if (-77 == errorNumber){
        warnInfo = @"道具箱中没有可以解除工具";
    }
    else if (-78 == errorNumber){
        warnInfo = @"正在被使用道具断电剪";
    }
    else if (-79 == errorNumber){
        warnInfo = @"道具不足";
    }
    else if (-80 == errorNumber){
        warnInfo = @"道具不能贈送";
    }
    else if (-81 == errorNumber){
        warnInfo = @"道具不能使用";
    }
    else if (-82 == errorNumber){
        warnInfo = @"已经参加活动";
    }
    else if (-83 == errorNumber){
        warnInfo = @"邀请人注册时间晚于被邀请人";
    }
    else if (-84 == errorNumber){
        warnInfo = @"邀请抽奖已过期";
    }
    else if (-85 == errorNumber){
        warnInfo = @"用户没有装扮";
    }
    else if (-86 == errorNumber){
        warnInfo = @"用户投票失败";
    }
    else if (-87 == errorNumber){
        warnInfo = @"数量错误";
    }
    else if (-88 == errorNumber){
        warnInfo = @"Q+用户的OPENID错误";
    }
    else if (-89 == errorNumber){
        warnInfo = @"Q+用户的OPENKEY错误";
    }
    else if (-90 == errorNumber){
        warnInfo = @"活动类型为空";
    }
    else if (-91 == errorNumber){
        warnInfo = @"金蛋已砸";
    }
    else if (-92 == errorNumber){
        warnInfo = @"被使用了OH SHIT道具";
    }
    else if (-93 == errorNumber){
        warnInfo = @"支持的辩题id为空";
    }
    else if (-94 == errorNumber){
        warnInfo = @"精灵ID";
    }
    else if (-95 == errorNumber){
        warnInfo = @"用户没有此装扮";
    }
    else if (-96 == errorNumber){
        warnInfo = @"装扮已过期";
    }
    else if (-97 == errorNumber){
        warnInfo = @"爱情问答编号错误";
    }
    else if (-98 == errorNumber){
        warnInfo = @"无照片头像";
    }
    else if (-199 == errorNumber){
        warnInfo = @"尚未登录";
    }
    else{
        warnInfo = @"未知错误";
    }
        return warnInfo;
}
@end
