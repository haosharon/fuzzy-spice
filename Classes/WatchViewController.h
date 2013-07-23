//
//  WatchViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/25/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "Game.h"
#import "BoardState.h"

@interface WatchViewController : BoardViewController {
	Game *watchGame;

}


@property (nonatomic, retain) Game *watchGame;

-(void) setInfoTableWithGame:(Game *)game;
-(void) setInfoTableWithState:(BoardState *)state;
@end
