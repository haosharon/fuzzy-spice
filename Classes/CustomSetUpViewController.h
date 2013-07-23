//
//  CustomSetUpViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/20/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "Piece.h"
#import "BoardState.h"


@interface CustomSetUpViewController : BoardViewController {

	NSMutableArray *setupPieces;
	NSMutableArray *piecesArray;
	NSArray *nameArray;
	NSMutableDictionary *stateInfo;
	UIImageView *activeIV, *imageIV;
	Piece *activePiece;
    BoardState *newState;
	
}

- (BOOL) stateIsValid;
-(void) setUpSidePieces;
-(NSString *) closestSquareToPoint:(CGPoint)point;
-(void) saveBoardStateAction;
-(void) createNewState;
-(void) setInfoTable;
- (void) saveBoardStateAction;

@end
