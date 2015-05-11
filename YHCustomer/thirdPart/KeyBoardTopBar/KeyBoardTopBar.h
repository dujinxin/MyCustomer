//
//  KeyBoardTopBar.h
//  cccStuff
//
//  Created by Danny Apple on 10-12-2.
//  Copyright 2010 yuanshu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol keyBoardTopBarDelegate <NSObject>
@optional
//下一项回调
-(void)keyBoardTopBarNext:(UITextField *)textField ; 
//上一项回调
-(void)keyBoardTopBarPrevious:(UITextField *)textField;

-(void)keyBoardTopBarButtonNext:(UITextField *)textField;
-(void)keyBoardTopBarButtonPrevious:(UITextField *)textField;
-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField;
@end

@interface KeyBoardTopBar : NSObject {
     id<keyBoardTopBarDelegate> _delegate; 
	UIToolbar *view;
	NSMutableArray *TextFields;
	BOOL allowShowPreAndNext;
	BOOL isInNavigationController;
	UIBarButtonItem *prevButtonItem;
	UIBarButtonItem *nextButtonItem;
	UIBarButtonItem *hiddenButtonItem;
	UIBarButtonItem *spaceButtonItem;
	UITextField *currentTextField;
   
}
@property(nonatomic,retain) UIToolbar *view;
@property(nonatomic,assign) id<keyBoardTopBarDelegate> delegate; 
@property(nonatomic,retain) UIBarButtonItem *nextButtonItem;
@property(nonatomic,retain) UIBarButtonItem *prevButtonItem;
@property(nonatomic,retain) NSArray *TextFields;
@property (retain,nonatomic) UITextField *currentTextField;
-(id)initWithArray:(NSArray *) array;
-(void)setAllowShowPreAndNext:(BOOL)isShow;
-(void)setIsInNavigationController:(BOOL)isbool;
-(void)ShowPrevious;
-(void)ShowNext;
-(void)ShowBar:(UITextField *)textField;
-(void)HiddenKeyBoard;
-(void)addTextField:(id)sender;
-(void)setTextFieldArray:(NSArray *) array;
@end
