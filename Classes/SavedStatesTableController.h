//
//  SavedStatesTableController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/29/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedStatesTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

	UINavigationController *parentController;
	NSMutableArray *savedStates, *savedStateIDs;
}

@property (nonatomic, retain) UINavigationController *parentController;
@property (nonatomic, retain) NSMutableArray *savedStates, *savedStateIDs;

-(IBAction) goBack:(id)sender;

@end
