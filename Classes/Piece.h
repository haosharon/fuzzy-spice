//
//  Piece.h
//  How To Chess
//
//  Created by Sharon Hao on 7/17/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Piece : NSObject <NSCoding>{
	NSMutableString *name, *square;
	BOOL white, hasMoved;
	int forward;
	

}

@property (nonatomic, retain) NSMutableString *name, *square;
@property BOOL white, hasMoved;
@property int forward;

-(NSMutableString *)getPieceName;
-(UIImage *) getPieceImage;
-(int) getForwardDirection;
-(void) resetValues;
-(void) setPieceWithPiece:(Piece *)piece;


@end
