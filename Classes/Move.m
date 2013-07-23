//
//  Move.m
//  How To Chess
//
//  Created by Sharon Hao on 7/16/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "Move.h"
#import "Piece.h"


@implementation Move

@synthesize kCastle, qCastle, check, checkmate, take, start, promote, enPassant, resign, draw, stalemate;
@synthesize moveNumber;
@synthesize endSquare, promotePiece, comments, startSquare, pieceTaken;
@synthesize aPiece;

- (void) initialize {

	kCastle = NO;
	qCastle = NO;
	check = NO;
	checkmate = NO;
	take = NO;
	promote = NO;
	enPassant = NO;
    resign = NO;
    draw = NO;
    stalemate = NO;
	
	endSquare = [[NSMutableString alloc] init];
	startSquare = [[NSMutableString alloc] init];
	//piece = [NSString alloc];
	aPiece = [[Piece alloc] init];
	promotePiece = [[NSMutableString alloc] init];
	comments = [[NSMutableString alloc] initWithString:@""];
	pieceTaken = [[NSMutableString alloc] initWithString:@" "];
	

}

- (void) resetValues {
	kCastle = NO;
	qCastle = NO;
	check = NO;
	checkmate = NO;
	take = NO;
	promote = NO;
	enPassant = NO;
    resign = NO;
    draw = NO;
    stalemate = NO;
	[pieceTaken setString:@""];
	
	
}

- (void) setMoveWithMove:(Move *)move {
	self.kCastle = move.kCastle;
	qCastle = move.qCastle;
	check = move.check;
	checkmate = move.checkmate;
	take = move.take;
	promote = move.promote;
	enPassant = move.enPassant;
    resign = move.resign;
    draw = move.draw;
	[self.endSquare setString:move.endSquare];
	[startSquare setString:move.startSquare];
	[promotePiece setString:move.promotePiece];
	[comments setString:move.comments];
	[pieceTaken setString:move.pieceTaken];
	moveNumber = move.moveNumber;
	[self setAPiece:move.aPiece];
}

- (void) setAPiece:(Piece *)piece {
	[aPiece.name setString:piece.name];
	aPiece.white = piece.white;
	[aPiece.square setString:piece.square];
	aPiece.hasMoved = piece.hasMoved;
	
}



-(id) initWithCoder:(NSCoder *)aDecoder {
	kCastle = [aDecoder decodeBoolForKey:@"kCastle"];
	qCastle = [aDecoder decodeBoolForKey:@"qCastle"];
	check = [aDecoder decodeBoolForKey:@"check"];
	checkmate = [aDecoder decodeBoolForKey:@"checkmate"];
	take = [aDecoder decodeBoolForKey:@"take"];
	promote = [aDecoder decodeBoolForKey:@"promote"];
	enPassant = [aDecoder decodeBoolForKey:@"enPassant"];
    resign = [aDecoder decodeBoolForKey:@"resign"];
    draw = [aDecoder decodeBoolForKey:@"draw"];
    stalemate = [aDecoder decodeBoolForKey:@"stalemate"];
	
	endSquare = [[aDecoder decodeObjectForKey:@"endSquare"] retain];
	startSquare = [[aDecoder decodeObjectForKey:@"startSquare"] retain];
	aPiece = [[aDecoder decodeObjectForKey:@"aPiece"] retain];
	promotePiece = [[aDecoder decodeObjectForKey:@"promotePiece"] retain];
	comments = [[aDecoder decodeObjectForKey:@"comments"] retain];
	start = [aDecoder decodeIntForKey:@"start"];
	moveNumber = [aDecoder decodeIntForKey:@"moveNumber"];
	pieceTaken = [[aDecoder decodeObjectForKey:@"pieceTaken"] retain];
    
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:kCastle forKey:@"kCastle"];
	[aCoder encodeBool:qCastle forKey:@"qCastle"];
	[aCoder encodeBool:check forKey:@"check"];
	[aCoder encodeBool:checkmate forKey:@"checkmate"];
	[aCoder encodeBool:take forKey:@"take"];
	[aCoder encodeBool:promote forKey:@"promote"];
	[aCoder encodeBool:enPassant forKey:@"enPassant"];
    [aCoder encodeBool:resign forKey:@"resign"];
    [aCoder encodeBool:draw forKey:@"draw"];
    [aCoder encodeBool:stalemate forKey:@"stalemate"];
	[aCoder encodeObject:endSquare forKey:@"endSquare"];
	[aCoder encodeObject:aPiece forKey:@"aPiece"];
	[aCoder encodeObject:promotePiece forKey:@"promotePiece"];
	[aCoder encodeObject:comments forKey:@"comments"];
	[aCoder encodeObject:startSquare forKey:@"startSquare"];
	[aCoder encodeInt:start forKey:@"start"];
	[aCoder encodeInt:moveNumber forKey:@"moveNumber"];
	[aCoder encodeObject:pieceTaken forKey:@"pieceTaken"];
	
} 

@end
