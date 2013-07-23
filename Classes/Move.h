//
//  Move.h
//  How To Chess
//
//  Created by Sharon Hao on 7/16/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"


@interface Move : NSObject <NSCoding> {
	//BOOL white;
	
	BOOL kCastle;
	BOOL qCastle;
	BOOL check;
	BOOL checkmate;
	BOOL take;
	BOOL promote;
	BOOL enPassant;
    BOOL resign;
    BOOL draw;
    BOOL stalemate;
	
	NSMutableString *promotePiece;
	NSMutableString *endSquare;
	NSMutableString *startSquare;
	NSMutableString *pieceTaken;
	//NSString *piece;
	Piece *aPiece;
	char start;
	
	int moveNumber;
	
	NSMutableString *comments;

}
@property (nonatomic, retain) NSMutableString *endSquare, *promotePiece, *startSquare, *pieceTaken;
@property (nonatomic, retain) NSMutableString *comments;
@property (nonatomic, retain) Piece *aPiece;
@property int moveNumber;
@property BOOL kCastle, qCastle, check, checkmate, take, promote, enPassant, resign, draw, stalemate;
@property char start;

- (void) initialize;
- (void) resetValues;
- (void) setMoveWithMove:(Move *)move;
- (void) setAPiece:(Piece *)piece;
@end
