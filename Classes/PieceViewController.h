//
//  PieceViewController.h
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"

@interface PieceViewController : BoardViewController {
	NSString *tmpFilename;
	NSMutableArray *tmpMainArray;
	NSArray *fileArray;
}

@property(nonatomic, retain) NSString *tmpFilename;
@property(nonatomic, retain) NSMutableArray *tmpMainArray;

-(IBAction) segmentValueChanged:(id)sender;

@end
