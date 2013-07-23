//
//  SavedGamesTable.h
//  How To Chess
//
//  Created by Sharon Hao on 7/27/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedGamesTable : UITableViewController {
	UINavigationController *parentController;
	NSMutableArray *savedGames;
	NSMutableArray *savedGameIDs;
}

@property (nonatomic, retain) UINavigationController *parentController;
@property (nonatomic, retain) NSMutableArray *savedGames;
@property (nonatomic, retain) NSMutableArray *savedGameIDs;

-(IBAction) goBack:(id)sender;

@end
