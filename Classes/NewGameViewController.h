//
//  NewGameViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/27/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"
#import "Game.h"

@interface NewGameViewController : PlayViewController <UIActionSheetDelegate> {
	Game *newGame;

}

@property (nonatomic, retain) Game *newGame;

- (void) createNewGame;
- (void) setInfoTable;
- (IBAction) exitAction:(id)sender;
- (IBAction) saveGame:(id)sender;
- (void) gameIsOver:(char)result;


@end
