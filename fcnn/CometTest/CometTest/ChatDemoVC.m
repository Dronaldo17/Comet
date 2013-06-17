//
//  ChatDemoVC.m
//  CometTest
//
//  Created by doujingxuan on 13-6-12.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import "ChatDemoVC.h"
#import "JSON.h"

@interface ChatDemoVC ()

@end

@implementation ChatDemoVC
@synthesize xsrf,sendString,receiveString;
- (void)dealloc
{
    [self clearAuthRequest];
    [self clearReceiveRequest];
    [self removeAllNotifications];
    self.xsrf = nil;
    self.sendString = nil;
    self.receiveString = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.xsrf = [DRTools getValueFromNSUserDefaultsByKey:XSRF];
    if ([self.xsrf length] > 0) {
        [self reciveMessage];
    }
    else{
        [self authlogin];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addNotifications];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma 按钮响应事件
-(IBAction)sendMessage:(id)sender
{
    [_inputBox resignFirstResponder];
    NSString * sendMessage = [NSString stringWithFormat:@"我:%@",[_inputBox text]];
    [_inputBox setText:@""];
    [self updateUIFromSpeaker:sendMessage byMessage:sendMessage];
    [self sendMessageRequestWithMessage:sendMessage];
}
-(IBAction)handUpdateMessage:(id)sender
{
    if (_receiveRequest) {
        [_receiveRequest clearDelegatesAndCancel];
        Block_release(_receiveRequest);
        _receiveRequest = nil;
    }
    [self reciveMessage];
}
#pragma 生成comet 请求
-(void)authlogin
{
    NSURL * url = [NSURL URLWithString:LOGIN_API];
    
    if (!_authLoginRequest) {
        _authLoginRequest = [[ASIHTTPRequest alloc] initWithURL:url]  ;
    }
    else{
        _authLoginRequest.url = url;
    }
      [_authLoginRequest setCompletionBlock:^{
        NSArray * responseCookies = [_authLoginRequest responseCookies];
        NSLog(@"responseCookies is %@",responseCookies);
        NSHTTPCookie * cooke = [responseCookies objectAtIndex:0];
        NSDictionary * dict = cooke.properties;
        NSLog(@"dict is %@",dict);
        
        self.xsrf = dict[VALUE];
        [DRTools syncNSUserDeafaultsByKey:XSRF withValue:self.xsrf];
        [_authLoginRequest clearDelegatesAndCancel];
        [_authLoginRequest release];
          _authLoginRequest = nil;
        [self reciveMessage];
    }];
    
    [_authLoginRequest setFailedBlock:^{
        NSError * error = [_authLoginRequest error];
        NSLog(@"error is %@",error);
       [_authLoginRequest clearDelegatesAndCancel];
        [_authLoginRequest release];
        _authLoginRequest = nil;
    }];
    [_authLoginRequest startAsynchronous];
}
-(void)reciveMessage
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSURL * url = [NSURL URLWithString:RECEIVE_API];
    if (!_receiveRequest) {
        _receiveRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    }
    else{
        _receiveRequest.url = url;
    }
    [_receiveRequest  setRequestMethod:@"POST"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_receiveRequest  setPostValue:self.xsrf forKey:XSRF];
    
    [_receiveRequest setTimeOutSeconds:TimeOut];
    [_receiveRequest setShouldAttemptPersistentConnection:NO];
    [_receiveRequest setNumberOfTimesToRetryOnTimeout:0];
   
    [self setATimeStampByType:@"请求发起时间"];

    [_receiveRequest setDidFinishSelector:@selector(receiveMessageSuccess:)];
    [_receiveRequest setDidFailSelector:@selector(receiveMessageFailed:)];
    [_receiveRequest setDelegate:self];
    
    [_receiveRequest startAsynchronous];
}
-(void)updateUIFromSpeaker:(NSString*)speaker byMessage:(NSString*)message
{
     _textView.text =[NSString stringWithFormat:@"%@\r\n%@",_textView.text,message];
}
/**Author:Ronaldo Description:发送需要另外字段  暂无法准确捕获*/
-(void)sendMessageRequestWithMessage:(NSString*)message
{
    if ( nil == message || [message length] <= 0) {
        
    }
    else{
        NSURL * url = [NSURL URLWithString:SEND_API];
      __block  ASIFormDataRequest * sendRequest = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
        [sendRequest setRequestMethod:@"POST"];
       [sendRequest setPostValue:self.xsrf forKey:XSRF];
        [sendRequest setPostValue:message forKey:@"body"];
        
        
        
        [sendRequest setCompletionBlock:^{
            NSString * responseString = [sendRequest  responseString];
            NSLog(@"responseString is %@",responseString);
            [DRTools tapAlertWithMessage:@"发送成功"];
        
        }];
        [sendRequest setFailedBlock:^{
            NSError * error = [sendRequest error];
            NSLog(@"error is %@",[error localizedDescription]);
            [DRTools tapAlertWithMessage:@"发送失败"];
        }];
        [sendRequest  startAsynchronous];
    }

}
-(void)setATimeStampByType:(NSString*)type
{
    NSString * waitString = [DRTools stringFromADate:[NSDate date] withFormat:@"hh:mm:ss"];
    
    [self updateUIFromSpeaker:nil byMessage:[NSString stringWithFormat:@"%@:%@",type,waitString]];
    
}
-(void)clearReceiveRequest
{
    if (_receiveRequest) {
        [_receiveRequest clearDelegatesAndCancel];
        [_receiveRequest release];
        _receiveRequest = nil;

    }
}
-(void)clearAuthRequest
{
    if (_authLoginRequest) {
        [_authLoginRequest clearDelegatesAndCancel];
        [_authLoginRequest release];
        _authLoginRequest = nil;
    }
}
-(void)receiveMessageSuccess:(ASIHTTPRequest*)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setATimeStampByType:@"成功接受消息时间"];
    NSString * responseString = [request  responseString];
    NSLog(@"responseString is %@",responseString);
    NSMutableDictionary * dict = [responseString JSONValue];
    NSLog(@"dict is %@",dict);
    NSMutableDictionary * tmpDict = [NSMutableDictionary dictionaryWithCapacity:2];
    tmpDict = dict[@"messages"][0];
    
    NSString * receivedMessage = [NSString stringWithFormat:@"%@:%@",tmpDict[@"from"],tmpDict[@"body"]];
    [self updateUIFromSpeaker:SPEAKER_OTHER byMessage:receivedMessage];
    [self clearReceiveRequest];
    [self reciveMessage];
}
-(void)receiveMessageFailed:(ASIHTTPRequest*)request
{
    [self setATimeStampByType:@"请求失败重连时间"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError * error = [request error];
    NSString * errorMessage = [DRTools parseHttpError:error];
    NSLog(@"error is %@",[error localizedDescription]);
    [DRTools tapAlertWithMessage:errorMessage];
    [self clearReceiveRequest];
    [self reciveMessage];
}

#pragma mark  键盘的收起
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendMessage:nil];
    return YES;
}

#pragma 监控网络
-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetWork:) name:NETWORK_NO_NETWORK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkIsOK:) name:NETWORK_WIFI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkIsOK:) name:NETWORK_2G_OR_3G object:nil];
}
-(void)removeAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeAllNotifications];
}
-(void)noNetWork:(NSNotification*)notification
{
    [self clearReceiveRequest];
}
-(void)networkIsOK:(NSNotification*)notification
{
    if (_receiveRequest) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    else{
        [self reciveMessage];
    }
}
@end
