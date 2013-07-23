//
//  MainViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/12/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface MainViewController : UIViewController < MFMailComposeViewControllerDelegate>
{	
	UIViewController *viewController;
	/*
	UITableView *myTableView;
	NSMutableArray *tableList;
	NSArray *catagories;
	*/
	
}

/*
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *tableList;
@property (nonatomic, retain) NSArray *catagories;
*/

-(IBAction) buttonClicked:(id)sender;
-(IBAction)emailMe:(id)sender;

@end
