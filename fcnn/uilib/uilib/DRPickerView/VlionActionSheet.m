//
//  VlionActionSheet.m
//  TestActionSheet
//
//  Created by Cui Lionel on 10-12-8.
//  Copyright 2010 vlion. All rights reserved.
//

#import "VlionActionSheet.h"

@implementation VlionActionSheet
@synthesize view;
@synthesize toolBar;
-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title
{//height = 84, 134, 184, 234, 284, 334, 384, 434, 484
	self = [super init];
    if (self) 
	{
		int theight = height - 40;
		int btnnum = theight/50;
		for(int i=0; i<btnnum; i++)
		{
			[self addButtonWithTitle:@" "];
		}
		toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		toolBar.barStyle = UIBarStyleDefault;
		
		UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title style: UIBarButtonItemStylePlain target: nil action: nil];
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
		UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(docancel)];
		UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, titleButton,fixedButton, rightButton, nil];
		[toolBar setItems: array];		
		[titleButton release];
		[leftButton  release];
		[rightButton release];
		[fixedButton release];
		[array       release];
		
		[self addSubview:toolBar];
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, height-44)];
		view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		[self addSubview:view];
    }
    return self;
}

- (void) addOKTarget:(id) target  selector:(SEL) selector{
    ok_target = target;
    ok_sel = selector;
}

- (void) addCancelTarget:(id) target  selector:(SEL) selector{
    cancel_target = target;
    cancel_sel = selector;
}

-(void)done
{
    if (nil != ok_target) {
        [ok_target performSelector:ok_sel];
    }
    
	[self dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)docancel
{
    if (nil != cancel_target) {
        [cancel_target performSelector:cancel_sel];
    }
    
	[self dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)dealloc
{
	[view release];
	[super dealloc];
}
@end
