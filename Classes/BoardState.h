//
//  BoardState.h
//  How To Chess
//
//  Created by Sharon Hao on 7/20/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BoardState : NSObject <NSCoding>{
	NSMutableArray *piecesArray;
	NSMutableDictionary *stateInfo;
	BOOL whiteToMove;
	NSMutableString *stateID;
    NSMutableString *comments;
}

@property (nonatomic, retain) NSMutableArray *piecesArray;
@property (nonatomic, retain) NSMutableDictionary *stateInfo;
@property BOOL whiteToMove;
@property (nonatomic, retain) NSMutableString *stateID;
@property (nonatomic, retain) NSMutableString *comments;

-(NSString *) getRandomNumber;
-(void) assignStateID;
		   
@end
