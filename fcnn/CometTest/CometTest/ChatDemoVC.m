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
    if (_authLoginRequest) {
        [_authLoginRequest release];
    }
    _authLoginRequest = nil;
    if (_receiveRequest) {
        [_receiveRequest release];
    }
    _receiveRequest = nil;
    
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
    [self updateUIFromSpeaker:sendMessage message:sendMessage];
}
-(IBAction)handUpdateMessage:(id)sender
{
    
}
#pragma 生成comet 请求
-(void)authlogin
{
    NSURL * url = [NSURL URLWithString:LOGIN_API];
    
    if (!_authLoginRequest) {
        _authLoginRequest = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease] ;
    }
    else{
        _authLoginRequest.url = url;
    }
      [_authLoginRequest setCompletionBlock:^{
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSArray * responseCookies = [_authLoginRequest responseCookies];
        NSLog(@"responseCookies is %@",responseCookies);
        NSHTTPCookie * cooke = [responseCookies objectAtIndex:0];
        NSDictionary * dict = cooke.properties;
        NSLog(@"dict is %@",dict);
        
        self.xsrf = dict[VALUE];
        [DRTools syncNSUserDeafaultsByKey:XSRF withValue:self.xsrf];
        [self reciveMessage];
    }];
    
    [_authLoginRequest setFailedBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError * error = [_authLoginRequest error];
        NSLog(@"error is %@",error);
    }];
    [_authLoginRequest startAsynchronous];
}
-(void)reciveMessage
{
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
    [_receiveRequest setTimeOutSeconds:60.0f];

    
//    [_receiveRequest setDidFinishSelector:@selector(receiveMessageSuccess:)];
//    [_receiveRequest setDidFailSelector:@selector(receiveMessageFailed:)];
//    [_receiveRequest setDelegate:self];
//    [_receiveRequest startAsynchronous];
    
    
    [_receiveRequest setCompletionBlock:^{
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString * responseString = [_receiveRequest  responseString];
        NSLog(@"responseString is %@",responseString);
                NSMutableDictionary * dict = [responseString JSONValue];
        NSLog(@"dict is %@",dict);
        NSMutableDictionary * tmpDict = [NSMutableDictionary dictionaryWithCapacity:2];
        tmpDict = dict[@"messages"][0];
        NSString * receivedMessage = [NSString stringWithFormat:@"%@:%@",tmpDict[@"from"],tmpDict[@"body"]];
        [self updateUIFromSpeaker:SPEAKER_OTHER message:receivedMessage];
        [_receiveRequest cancel];
        [_receiveRequest release];
        _receiveRequest = nil;
        [self reciveMessage];
    }];
    [_receiveRequest setFailedBlock:^{
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError * error = [_receiveRequest error];
        NSLog(@"error is %@",error);
        [_receiveRequest cancel];
        [_receiveRequest release];
         _receiveRequest = nil;
        [self reciveMessage];
    }];
    [_receiveRequest startAsynchronous];
}
-(void)updateUIFromSpeaker:(NSString*)speaker message:(NSString*)message
{
     _textView.text =[NSString stringWithFormat:@"%@\r\n%@",_textView.text,message];
}
//-(void)receiveMessageSuccess:(ASIHTTPRequest*)request
//{
//           NSString * responseString = [request  responseString];
//            NSLog(@"responseString is %@",responseString);
//                    NSMutableDictionary * dict = [responseString JSONValue];
//            NSLog(@"dict is %@",dict);
//    
//        NSMutableDictionary * tmpDict = [NSMutableDictionary dictionaryWithCapacity:2];
//        tmpDict = dict[@"messages"][0];
//    
//    
//            NSString * receivedMessage = [NSString stringWithFormat:@"%@:%@",tmpDict[@"from"],tmpDict[@"body"]];
//            [self.receiveString appendString:receivedMessage];
//            [self reciveMessage];
//           
//
//}
//-(void)receiveMessageFailed:(ASIHTTPRequest*)request
//{
//    [request cancel];
//    NSError * error = [_receiveRequest error];
//    NSLog(@"error is %@",error);
//    [self reciveMessage];
//}

#pragma mark  键盘的收起
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
