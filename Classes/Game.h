//
//  Game.h
//  How To Chess
//
//  Created by Sharon Hao on 7/27/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Game : NSObject <NSCoding>{
	NSMutableArray *movesArray; //array of moves 
	NSMutableDictionary *gameInfo; //dictonary of propNames, properties {Date: "12/9/2001"}
	NSMutableString *gameID;
    NSMutableString *comments;
    char result; ///can be either 'W', 'B', 'D', 'N' means game not finished (no result)

}

@property (nonatomic, retain) NSMutableArray *movesArray;
@property (nonatomic, retain) NSMutableDictionary *gameInfo;
@property (nonatomic, retain) NSMutableString *gameID;
@property (nonatomic, retain) NSMutableString *comments;
@property char result;

-(void) assignGameID;
-(NSString *) getRandomNumber;
-(NSString *) convertToString;

@end
