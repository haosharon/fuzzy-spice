//
//  SetupViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/13/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"

@interface SetupViewController : BoardViewController {
	NSString *tmpFilename;
	NSArray *fileArray;
	NSMutableArray *tmpMainArray;
}

@property (nonatomic, retain) NSString *tmpFilename;
@property (nonatomic, retain) NSArray *fileArray;
@property (nonatomic, retain) NSMutableArray *tmpMainArray;

@end
