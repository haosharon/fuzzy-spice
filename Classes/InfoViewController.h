//
//  InfoViewController.h
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
UITableViewDataSource>
{
	///UINavigationController *parentController;
	UITableView *myTableView;
	NSDictionary *gameInfo;
	NSArray *propNames, *properties;

	
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSDictionary *gameInfo;


@end
