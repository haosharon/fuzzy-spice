//
//  PlayViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/17/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchViewController.h"
#import "Piece.h"
#import "Move.h"


@interface PlayViewController : WatchViewController {
	Piece *activePiece;
	UIImageView *activeIV, *imageIV;
	BOOL whiteToMove;
	int moveNumber;
	UIView *promView;
	Move *activeMove;
	
	
	
}

@property BOOL whiteToMove;
@property (nonatomic, retain) UIView *promView;

- (NSString *)closestSquareToPoint:(CGPoint)point;
- (void) makeMove;
- (IBAction) backAction:(id)sender;
- (IBAction) forwardAction:(id)sender;
-(IBAction)optionsAction:(id)sender;
- (void) buildPromotionView;
- (void) setPromoteButtons;
- (IBAction) promotePieceAction:(id)sender;
- (void) resign:(BOOL)whiteResigns;
-(void) draw;

/*
- (void) buildPromoteView;
- (IBAction) choosePromotePiece:(id)sender;
- (void) promoteViewShow;
*/

@end