//
//  TableViewController.h
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
												UITableViewDataSource>
{
	UITableView *myTableView;
	NSArray *tableArray;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSArray *tableArray;

- (void)setArrayWithString:(NSString *)filename;
@end
