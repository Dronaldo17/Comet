//
//  VlionActionSheet.h
//  TestActionSheet
//
//  Created by Cui Lionel on 10-12-8.
//  Copyright 2010 vlion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface VlionActionSheet : UIActionSheet 
{
	UIToolbar* toolBar;
	UIView* view;
    
    id ok_target;
    SEL ok_sel;
    
    id cancel_target;
    SEL cancel_sel;
}

@property(nonatomic,retain)UIView* view;
@property(nonatomic,retain)UIToolbar* toolBar;

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title;
/*因为是通过给ActionSheet 加 Button来改变ActionSheet, 所以大小要与actionsheet的button数有关
height = 84, 134, 184, 234, 284, 334, 384, 434, 484
 如果要用self.view = anotherview.  那么another的大小也必须与view的大小一样
*/

- (void) addOKTarget:(id) target  selector:(SEL) selector;
- (void) addCancelTarget:(id) target  selector:(SEL) selector;
-(void)done;

@end
