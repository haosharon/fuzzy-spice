//
//  Notation.h
//  How To Chess
//
//  Created by Sharon Hao on 7/16/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Notation : NSObject {
	NSString *fileName;
	NSString *txtString;
	NSString *whitePlayer, *blackPlayer, *title;
	NSMutableArray *moves;
	NSMutableDictionary *gameInfo;
	int	gameType;
	
}

@property (nonatomic, retain) NSString *whitePlayer, *blackPlayer, *title;

- (void) setFileName:(NSString *)string;
- (void) initialize;
- (void) getTxtString;
- (NSArray *) getMovesArray;
- (NSDictionary *) getInfoArray;
- (void) getGameInfo;
- (void) editInfoString:(NSString *)infoString;
- (void) editMoveString:(NSMutableString *)moveString;

@end
