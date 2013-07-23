//
//  BoardViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/25/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Notation.h"
#import "Piece.h"
#import "Move.h"
#import "BoardState.h"
#import "InfoTableController.h"


@interface BoardViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate>{
	NSMutableDictionary *squareDict;
	NSDictionary *piecesDict;
	NSMutableArray *mainArray;
	NSMutableArray *whitePieces, *blackPieces;
	NSMutableArray *whiteTaken, *blackTaken;
	NSMutableArray *movesArray;
	NSMutableArray *movesMade;
    NSMutableArray *letLabels;
    NSMutableArray *numLabels;
	BOOL white, black;
	BOOL whiteMove;
    BOOL soundIsOn;
	NSString *filename;
	int moveCount;
	Notation *gameNotation;
	UITextView *textComments;
	UIButton *forwardButton, *backButton, *noteButton;
	InfoTableController *infoTable;
	BOOL isBoardFlipped;
    BOOL gameIsOver;
	UITextField *stateTitleTextField;
    UIColor *backColor;
	
	
	
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) IBOutlet InfoTableController *infoTable;
@property (nonatomic, retain) NSMutableArray *movesArray;
@property (nonatomic, retain) UITextField *stateTitleTextField;

-(void) buildBoard;
-(void) flipBoard;
-(void) clearBoard;
-(void) setUpTextandButtons;
-(void) setUpPiecesFromState:(BoardState *)state;
-(void) setUpPiecesRegular;
-(void) addPiece:(Piece *)piece;

-(void) highlightSquare:(NSString *)key withColor:(UIColor *)color;
-(void) unhighlightSquare:(NSString *)key;
-(void) movePiece:(Piece *)aPiece withMove:(Move *)aMove;
-(void) carryOutMove;
-(NSString *) convertMoveToString:(Move *)nextMove;
-(void) addMoveToComments:(Move *)nextMove;
-(Piece *)getPiece:(Move *)givenMove andColor:(BOOL)color;
-(Piece *)getColor:(BOOL)color pieceOnSquare:(NSString *)square;
-(BOOL) piece:(Piece *)potPiece canMakeMove:(Move *)move checkForCheck:(BOOL)check;
-(BOOL) isInCheck:(BOOL)color withMove:(Move *)move;
-(BOOL) isInCheckmate:(BOOL)color;
-(BOOL) pathIsEmptyFromStart:(NSString *)startSquare toEnd:(NSString *)endSquare;
-(BOOL) squareIsEmpty:(NSString *)square;
-(BOOL) color:(BOOL)color hasPieceOnSquare:(NSString *)square;
-(IBAction) backAction:(id)sender;
-(IBAction) forwardAction:(id)sender;
-(IBAction) goBack:(id)sender;
-(void) removeLastMoveAndComment:(BOOL)rmComment;
-(void) playSound;
-(void) resetBoard;
- (void) gameIsOver:(char)result;
-(IBAction) getInfo:(id)sender;
-(IBAction)optionsAction:(id)sender;
-(void) resign:(BOOL)whiteResigns;
-(void) draw;
- (void) saveBoardStateAction;
-(void) askForStateTitle;
-(void) saveBoardState;
- (void)flipTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end
