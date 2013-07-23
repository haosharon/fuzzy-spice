//
//  Notation.m
//  How To Chess
//
//  Created by Sharon Hao on 7/16/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "Notation.h"
#import "Move.h"
#import "Piece.h"


@implementation Notation

@synthesize whitePlayer, blackPlayer, title;

- (void) setFileName:(NSString *)string {
	fileName = [[NSString alloc] initWithString:string];
}

- (void) initialize {
	NSLog(@"initialize");
	gameInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
	moves = [[NSMutableArray alloc] init];
	[self getTxtString];
	[self getGameInfo];
}

- (void) getTxtString {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
	txtString = [[NSString alloc] initWithContentsOfFile:filePath];
	//NSLog(@"txtstring %@", txtString);
}

- (NSArray *) getMovesArray {
	return moves;
}

- (NSDictionary *) getInfoArray {
	return gameInfo;
}

- (void) getGameInfo {
	NSMutableArray *tmpArray;
	tmpArray = [[[NSMutableArray alloc] initWithArray:[txtString componentsSeparatedByString:@"\n"]] autorelease];
	NSMutableString *tmpString = [[NSMutableString alloc] init];

	for (int i = 0; i < [tmpArray count]; i ++) {
		tmpString = [NSMutableString stringWithString:[tmpArray objectAtIndex:i]];
		if ([tmpString characterAtIndex:0] == '[') {
			//is commentary
			[self editInfoString:tmpString];
		}
		else if ([tmpString length] > 0) {
			if ([tmpString characterAtIndex:0] >= '0' && [tmpString characterAtIndex:0] <= '9') {
				// is move
				NSLog(@"move, %@", tmpString);
				[self editMoveString:tmpString];
				
				
			}
		}

		else {
			NSLog(@"error %@, index %d", tmpString, i);
		}

	}
	
	
	
	
	
	
	
	
	
}

- (void) editInfoString:(NSString *)infoString {
	NSMutableString *propertyName = [[[NSMutableString alloc] initWithCapacity:[infoString length]] autorelease];
	NSMutableString *property = [[[NSMutableString alloc] initWithCapacity:[infoString length]] autorelease];
	BOOL isProperty = NO;
	for (int i = 0; i < [infoString length]; i++) {
		char tmpC = [infoString characterAtIndex:i];
		if (!isProperty) {
			//property name
			if (tmpC == '[') {
				continue;
			}
			else if (tmpC == '"') {
				isProperty = YES;
			}
			else {
				[propertyName appendFormat:@"%c", tmpC];
			}


		}
		else {
			if (tmpC == '"') {
				break;
			}
			else {
				[property appendFormat:@"%c", tmpC];
			}

		}
	

	}
	while ([propertyName characterAtIndex:[propertyName length] - 1] == ' ') {
		[propertyName deleteCharactersInRange:NSMakeRange([propertyName length] - 1, 1)];
	}
	while ([propertyName characterAtIndex:0] == ' ') {
		[propertyName deleteCharactersInRange:NSMakeRange(0, 1)];
	}
	while ([property characterAtIndex:[property length] - 1] == ' ') {
		[property deleteCharactersInRange:NSMakeRange([property length] - 1, 1)];
	}
	while ([property characterAtIndex:0] == ' ') {
		[property deleteCharactersInRange:NSMakeRange(0, 1)];
	}
			
		
	NSLog(@"property name: %@, property: %@", propertyName, property);
	[gameInfo setObject:property forKey:propertyName];
	
	
	
}

- (void) editMoveString:(NSMutableString *)moveString {

	
	NSMutableString *tmpString = [[[NSMutableString alloc] init] autorelease];
	//NSMutableString *tmpCommentary = [[[NSMutableString alloc] init] autorelease];
	NSString *comment = nil;
	
	if ([moveString rangeOfString:@"{"].length > 0) {
		int startIndex = [moveString rangeOfString:@"{"].location;
		int stopIndex = [moveString rangeOfString:@"}"].location;
		NSLog(@"start:%d stop:%d", startIndex, stopIndex);
		comment = [[NSString alloc] initWithString:[moveString substringWithRange:NSMakeRange(startIndex + 1, stopIndex - startIndex - 1)]];
		NSLog(@"comment .%@.", comment);
		[(NSMutableString *)moveString deleteCharactersInRange:NSMakeRange(startIndex - 1, stopIndex - startIndex + 2)];
		NSLog(@"moveString .%@.", moveString);
	}
	
	NSArray *moveArray = [moveString componentsSeparatedByString:@" "];
	int mode = 0; //0 - number, 1 - whiteMove, 2 - blackMove
	int moveNumber;
	
	
	for (int i = 0; i < [moveArray count]; i ++) {
		tmpString = [NSMutableString stringWithString:[moveArray objectAtIndex:i]];
		
		if (mode == 0) {

			moveNumber = [[tmpString substringToIndex:([tmpString length] - 1)] intValue];
			NSLog(@"move number %d", moveNumber);
			mode ++;
		}
		else if (mode == 1 || mode == 2) {
			Move *move = [[Move alloc] init];
			[move initialize];
			move.moveNumber = moveNumber;
			if (comment) {
				[move.comments setString:comment];
			}
			if (mode == 1) {
				move.aPiece.white = YES;
			}
			else {
				move.aPiece.white = NO;
			}

			if ([tmpString characterAtIndex:([tmpString length] - 1)] == '+') {
				//check or checkmate
				move.check = YES;
				
				[tmpString deleteCharactersInRange:NSMakeRange([tmpString length] - 1, 1)];
				if ([tmpString characterAtIndex:([tmpString length] - 1)] == '+') {
					//checkmate
					move.check = NO;
					move.checkmate = YES;
					[tmpString deleteCharactersInRange:NSMakeRange([tmpString length] - 1, 1)];
				}
				
			}
			//check for castling
			if ([tmpString characterAtIndex:0] == 'O') {
				[move.aPiece.name setString:@"K"];
				if ([tmpString length] == 3) {
					move.kCastle = YES;
					
				}
				else if ([tmpString length] == 5) {
					move.qCastle = YES;
				}
				else {
					NSLog(@"error, %@", tmpString);
				}
				
			}
			else {
				char c = [tmpString characterAtIndex:0];
				if (c >= 'A' && c <= 'Z' ) {
					//move is ex. Ne4, Nxe4
					[move.aPiece.name setString:[NSString stringWithFormat:@"%c", c]];
					if ([tmpString length] == 3) {
						//Ne4
						[move.endSquare setString:[tmpString substringWithRange:NSMakeRange(1, 2)]];
					}
					else if ([tmpString length] == 4){
						//Nxe5
						move.take = YES;
						[move.endSquare setString:[tmpString substringWithRange:NSMakeRange(2, 2)]];
					}
					
				}
				else {
					if ([tmpString characterAtIndex:1] >= 'A' && [tmpString characterAtIndex:1] <= 'Z') {
						//gNe6 or gNxe6
						move.start = [tmpString characterAtIndex:0];
						[tmpString deleteCharactersInRange:NSMakeRange(0, 1)];
						//gNe5, gNxe5
						c = [tmpString characterAtIndex:0];
						[move.aPiece.name setString:[NSString stringWithFormat:@"%c", c]];
						if ([tmpString length] == 3) {
							//Ne4
							[move.endSquare setString:[tmpString substringWithRange:NSMakeRange(1, 2)]];
						}
						else if ([tmpString length] == 4){
							//Nxe5
							move.take = YES;
							[move.endSquare setString:[tmpString substringWithRange:NSMakeRange(2, 2)]];
						}
						
					}
					
					else {
						//piece is a pawn. move is ex e4
						[move.aPiece.name setString:@"P"];
						if ([tmpString characterAtIndex:([tmpString length] - 2)] == '=') {
							//promoted ex e8=Q, fxe8=Q
							move.promote = YES;
							[move.promotePiece setString:[NSString stringWithFormat:@"%c", [tmpString characterAtIndex:([tmpString length] - 1)]]];
							[tmpString deleteCharactersInRange:NSMakeRange([tmpString length] - 2, 2)];
						}
						if ([tmpString length] == 2) {
							//move is ex e4
							move.endSquare = tmpString;
						}
						else if ([tmpString characterAtIndex:1] == 'x') {
							//move is ex exf5
							move.take = YES;
							move.start = [tmpString characterAtIndex:0];
							[move.endSquare setString:[tmpString substringWithRange:NSMakeRange(2, 2)]];
						}
						
					}
				}
				
			}
			[moves addObject:move];
			
			mode ++;
		}
		/*
		else if (mode == 2 || mode == 4) {
			if ([tmpString characterAtIndex:0] == '{') {
				NSMutableString *tmp = [[[NSMutableString alloc] init] autorelease];
				
				int a = i;
				tmpCommentary = [NSString stringWithString:@""];
				while (YES) {
					tmp = [moveArray objectAtIndex:a];
					[tmpCommentary appendFormat:@"%@", tmp];
					if ([tmp characterAtIndex:([tmp length] - 1)] == '}') {
						break;
					}
				}
				move.comments = tmpCommentary;
				tmpCommentary = [NSString stringWithString:@""];
			}
			if ([move.comments isEqual:[NSString stringWithFormat:@""]]) {
				[moves addObject:move];
				NSLog(@"piece:%@, end square:%@, move number: %d", move.piece, move.endSquare, move.moveNumber);
				Move *move = [[Move alloc] init];
				[move initialize];
				mode ++;
			}
			else if ([tmpString characterAtIndex:([tmpString length] - 1)] == '}') {
				[moves addObject:move];
				NSLog(@"piece:%@, end square:%@, move number: %d", move.piece, move.endSquare, move.moveNumber);
				Move *move = [[Move alloc] init];
				[move initialize];
				
				mode ++;
			}
		}
		 */
	}
	
}


@end
