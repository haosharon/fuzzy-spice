//
//  InfoTableController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/25/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Game.h"
#import "BoardState.h"



@interface InfoTableController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, 
UITableViewDelegate, UITableViewDataSource, 
UITextViewDelegate, MFMailComposeViewControllerDelegate> {
	UIViewController *parentController;

    Game *game;
    BoardState *state;
    NSMutableString *comments;
	NSMutableDictionary *gameInfo;
	NSMutableArray *propNames, *properties;
	NSArray *mandatoryProp;
	UITextField *activeField;
    UITextView *activeView;
	BOOL keyboardIsShown;
	//UIScrollView *tableContainer;
	UITableView *myTableView;
    BOOL newState;
}

@property (nonatomic, retain) NSMutableDictionary *gameInfo;
@property (nonatomic, retain) UIViewController *parentController;
//@property (nonatomic, retain) IBOutlet UIScrollView *tableContainer;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) UITextView *activeView;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) BoardState *state;
@property (nonatomic, retain) NSMutableString *comments;
@property BOOL newState;


- (void)emailGame:(Game *)gameToSend;

- (void)dismissKeyboard;
- (void) registerForKeyboardNotifications;
- (void) scrollToTextFieldInView:(UITextField *)textfield;
- (void) scrollToTextViewInView:(UITextView *)textview;
- (void) resizeViewByHeight:(int)heightDiff;
- (void) saveGameInfo;
- (void) setResult;
- (IBAction)changeNextMove:(id)sender;

@end
