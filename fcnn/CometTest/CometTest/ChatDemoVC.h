//
//  ChatDemoVC.h
//  CometTest
//
//  Created by doujingxuan on 13-6-12.
//  Copyright (c) 2013年 FCNN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface ChatDemoVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextView * _textView;
    IBOutlet UITextField * _inputBox;
   __block ASIHTTPRequest * _authLoginRequest;
   __block ASIFormDataRequest * _receiveRequest;
}
@property (nonatomic,retain)NSMutableString * sendString;
@property (nonatomic,retain)NSMutableString * receiveString;
@property (nonatomic,retain)NSString * xsrf;
-(IBAction)sendMessage:(id)sender;
-(IBAction)handUpdateMessage:(id)sender;
@end
