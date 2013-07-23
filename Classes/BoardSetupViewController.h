//
//  BoardSetupViewController.h
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BoardSetupViewController : UIViewController {
	NSMutableDictionary *squareDict;
	NSDictionary *piecesDict;
	NSMutableArray *setUpArray;
	BOOL white, black;
	
}

-(void) buildBoard;
-(void) addPieces:(NSString *)pieces color:(BOOL)white;
-(NSArray *) makeArrayFromFile:(NSString *)filePath;
-(NSArray *) makeArrayFromString:(NSString *)string;


@end
