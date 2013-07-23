//
//  SettingsTableViewController.h
//  How To Chess
//
//  Created by Sharon Hao on 7/28/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> {

	NSMutableDictionary *settingsDict;
	NSMutableArray *propNames, *properties;
    UISwitch *soundSwitch;
}

@property (nonatomic, retain) NSMutableDictionary *settingsDict;
@property (nonatomic, retain) NSMutableArray *propNames, *properties;


-(IBAction) goBack:(id)sender;
-(IBAction)soundChanged:(id)sender;

@end
