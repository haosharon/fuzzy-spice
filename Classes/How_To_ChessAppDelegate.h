//
//  How_To_ChessAppDelegate.h
//  How To Chess
//
//  Created by Sharon Hao on 7/12/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface How_To_ChessAppDelegate : NSObject <UIApplicationDelegate, UITabBarDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
	MainViewController *mainTable;
	//UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
//@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet MainViewController *mainTable;
@property (nonatomic, retain) IBOutlet UIWindow *window;

-(void) setRegularBoardState;


@end

