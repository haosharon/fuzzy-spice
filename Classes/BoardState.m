//
//  BoardState.m
//  How To Chess
//
//  Created by Sharon Hao on 7/20/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "BoardState.h"


@implementation BoardState

@synthesize piecesArray;
@synthesize stateInfo;
@synthesize whiteToMove;
@synthesize stateID;
@synthesize comments;

-(id)init {
	piecesArray = [[NSMutableArray alloc] init];
	stateInfo = [[NSMutableDictionary alloc] init];
	whiteToMove = YES;
    comments = [[NSMutableString alloc] init];
    stateID = [[NSMutableString alloc] init];
	return self;
}


-(NSString *) getRandomNumber {
	int i = 6;
	int digit;
	NSMutableString *tmp = [[[NSMutableString alloc] initWithCapacity:6] autorelease];
	//six digit number
	while (i) {
		digit = arc4random()%10;
		[tmp appendFormat:@"%d", digit];
		i--;
	}
	NSLog(@"%@", tmp);
	//check to make sure game id doesn't exist already
	//if it contains, recurse.
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSArray *savedStateIDs = [prefs arrayForKey:@"Saved State IDs"];
	if (savedStateIDs) {
		for (int i = 0; i < [savedStateIDs count] ; i ++) {
			if ([tmp isEqualToString:[savedStateIDs objectAtIndex:i]]) {
				return [self getRandomNumber];
			}
		}
		return tmp;
	}
	//else, return
	return tmp;
}

-(void) assignStateID {
    [stateID setString:[self getRandomNumber]];
    
}

-(id) initWithCoder:(NSCoder *)aDecoder {
	piecesArray = [[aDecoder decodeObjectForKey:@"piecesArray"] retain];
	stateInfo = [[aDecoder decodeObjectForKey:@"stateInfo"] retain];
	whiteToMove = [aDecoder decodeBoolForKey:@"whiteToMove"];
	stateID = [[aDecoder decodeObjectForKey:@"stateID"] retain];
    comments = [[aDecoder decodeObjectForKey:@"comments"] retain];
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:piecesArray forKey:@"piecesArray"];
	[aCoder encodeObject:stateInfo forKey:@"stateInfo"];
	[aCoder encodeBool:whiteToMove forKey:@"whiteToMove"];
	[aCoder encodeObject:stateID forKey:@"stateID"];
    [aCoder encodeObject:comments forKey:@"comments"];
}

@end
