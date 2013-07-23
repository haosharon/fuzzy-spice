//
//  Game.m
//  How To Chess
//
//  Created by Sharon Hao on 7/27/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "Game.h"
#import "Move.h"

@implementation Game

@synthesize movesArray;
@synthesize gameInfo;
@synthesize gameID;
@synthesize comments;
@synthesize result;

-(id) init {
	movesArray = [[NSMutableArray alloc] init];
	gameInfo = [[NSMutableDictionary alloc] init];
	gameID = [[NSMutableString alloc] initWithCapacity:6];
    comments = [[NSMutableString alloc] init];
    result = 'N';
    
	return self;
}

-(NSString *) convertToString {
    NSMutableString *returnString = [[NSMutableString alloc] init];
    //first, add game info
    NSArray *propNames = [[NSArray alloc] initWithObjects:@"Date", @"White", @"Black", @"Result", nil];
    for (int i = 0; i < [propNames count]; i++) {
        [returnString appendFormat:@"["];
        //[returnString appendFormat:@"%@",[[gameInfo allKeys] objectAtIndex:i]];
        [returnString appendFormat:@"%@", [propNames objectAtIndex:i]];
        [returnString appendFormat:@" \""];
        //[returnString appendFormat:@"%@", [[gameInfo allValues] objectAtIndex:i]];
        [returnString appendFormat:@"%@", [gameInfo objectForKey:[propNames objectAtIndex:i]]];
        [returnString appendFormat:@"\"]\n"];
    }
    if ([gameInfo count] > [propNames count]) {
        ///this may need testing later
        //there are additional properties
        for (int i = 0; i < [gameInfo count]; i ++) {
            if ([propNames containsObject:[[gameInfo allKeys] objectAtIndex:i]] ) {
                [returnString appendFormat:@"["];
                [returnString appendFormat:@"%@",[[gameInfo allKeys] objectAtIndex:i]];
                [returnString appendFormat:@" \""];
                [returnString appendFormat:@"%@", [[gameInfo allValues] objectAtIndex:i]];
                [returnString appendFormat:@"\"]\n"];
            }
        }
    }
    //then add moves
    //moves
    Move *tmpMove;
    for (int i = 0; i < [movesArray count]; i ++) {
        tmpMove = [movesArray objectAtIndex:i];
        if (tmpMove.aPiece.white) {
            [returnString appendFormat:@"%d. ", tmpMove.moveNumber];
        }
        if (tmpMove.kCastle || tmpMove.qCastle) {
            //castling
        }
        else {
            if (tmpMove.start) {
                [returnString  appendFormat:@"%c", tmpMove.start];
            }
            [returnString appendFormat:@"%@", tmpMove.aPiece.name];
            if (tmpMove.take) {
                [returnString appendFormat:@"x"];
            }
            [returnString appendFormat:@"%@", tmpMove.endSquare];
            if (tmpMove.promote) {
                [returnString appendFormat:@"=%@", tmpMove.promotePiece];
            }
        }
        
        if (tmpMove.check) {
            [returnString appendFormat:@"+"];
        }
        else if (tmpMove.checkmate) {
            [returnString appendFormat:@"++"];
        }
        [returnString appendFormat:@" "];
        
        
        
        
   
        
        
    }
    
    
    
    //then add comments
    if (comments) {
        [returnString appendFormat:@"\n\n%@", comments];
    }
    
    
    
    return returnString;
    
    
    
    
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
	NSArray *savedGameIDs = [prefs arrayForKey:@"Saved Game IDs"];
	if (savedGameIDs) {
		for (int i = 0; i < [savedGameIDs count] ; i ++) {
			if ([tmp isEqualToString:[savedGameIDs objectAtIndex:i]]) {
				return [self getRandomNumber];
			}
		}
		return tmp;
	}
	//else, return
	return tmp;
}

-(void) assignGameID {
	[gameID setString:[self getRandomNumber]];
	
	
}

-(id) initWithCoder:(NSCoder *)aDecoder {
	movesArray = [[aDecoder decodeObjectForKey:@"movesArray"] retain];
	gameInfo = [[aDecoder decodeObjectForKey:@"gameInfo"] retain];
	gameID = [[aDecoder decodeObjectForKey:@"gameID"] retain];
    comments = [[aDecoder decodeObjectForKey:@"comments"] retain];
    result = [aDecoder decodeIntForKey:@"result"];
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:movesArray forKey:@"movesArray"];
	[aCoder encodeObject:gameInfo forKey:@"gameInfo"];
	[aCoder encodeObject:gameID forKey:@"gameID"];
    [aCoder encodeObject:comments forKey:@"comments"];
    [aCoder encodeInt:result forKey:@"result"];
}

@end
