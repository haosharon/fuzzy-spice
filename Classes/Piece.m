//
//  Piece.m
//  How To Chess
//
//  Created by Sharon Hao on 7/17/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "Piece.h"


@implementation Piece

@synthesize name, square;
@synthesize white, hasMoved;
@synthesize forward;

-(id)init {
	name = [[NSMutableString alloc] initWithCapacity:1];
	square = [[NSMutableString alloc] initWithCapacity:2];
	white = NO;
	hasMoved = NO;
	forward = 1;
	return self;
}

-(void) setPieceWithPiece:(Piece *)piece {
	[self.name setString:piece.name];
	[self.square setString:piece.square];
	white = piece.white;
	hasMoved = piece.hasMoved;
	forward = [self getForwardDirection];
}


-(void) resetValues {
	white = NO;
	hasMoved = NO;
	forward = 1;
	[name setString:@" "];
	[square setString:@"  "];
}


-(int) getForwardDirection {
	if (white) {
		forward = 1;
	}
	else {
		forward = -1;
	}
	return forward;

}

-(NSString *)getPieceName {
	NSArray *objects = [[[NSArray alloc] initWithObjects:@"pawn", @"knight", @"bishop", @"rook", @"queen", @"king", nil] autorelease];
	NSArray *keys = [[[NSArray alloc] initWithObjects:@"P", @"N", @"B", @"R", @"Q", @"K", nil] autorelease];
	NSDictionary *pieceDictionary = [[[NSDictionary alloc] initWithObjects: objects forKeys:keys] autorelease];
	return [pieceDictionary objectForKey:name];
}

-(UIImage *) getPieceImage {
	NSString *prefix = [[NSString alloc] init];
	if (white) {
		prefix = @"w_";
	}
	else {
		prefix = @"b_";
	}
	NSString *filename = [[[NSString alloc] initWithFormat:@"%@%@.png", prefix, [self getPieceName]] autorelease];
	return [UIImage imageNamed:filename];

}



-(void) dealloc {
	[name release];
	[square release];
	[super dealloc];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
	name = [[aDecoder decodeObjectForKey:@"name"] retain];
	square = [[aDecoder decodeObjectForKey:@"square"] retain];
	white = [aDecoder decodeBoolForKey:@"pieceColor"] ;
	hasMoved = [aDecoder decodeBoolForKey:@"hasMoved"];
	forward = [aDecoder decodeIntForKey:@"forward"];
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:square forKey:@"square"];
	[aCoder encodeBool:white forKey:@"pieceColor"];
	[aCoder encodeBool:hasMoved forKey:@"hasMoved"];
	[aCoder encodeInt:forward forKey:@"forward"];
}


@end
