//
//  MainViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/12/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "MainViewController.h"
#import "BoardSetupViewController.h"
#import "SetupViewController.h"
#import "TableViewController.h"
#import "PlayViewController.h"
#import "CustomSetUpViewController.h"
#import "WatchViewController.h"
#import "NewGameViewController.h"
#import "SavedGamesTable.h"
#import "SettingsTableViewController.h"
#import "SavedStatesTableController.h"
#import <QuartzCore/QuartzCore.h>

#define TIME_FOR_SHRINKING 0.41f // Has to be different from SPEED_OF_EXPANDING and has to end in 'f'
#define TIME_FOR_EXPANDING 0.40f // Has to be different from SPEED_OF_SHRINKING and has to end in 'f'
#define SCALED_DOWN_AMOUNT 0.01  // For example, 0.01 is one hundredth of the normal size


const float RED = 100;
const float GREEN = 0;
const float BLUE = 0;




@implementation MainViewController
/*
@synthesize tableList, myTableView;
@synthesize catagories;
*/
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"Chess Saver";
	UIColor *buttonColor = [[UIColor alloc] initWithRed:(RED/255) green:(GREEN/255) blue:(BLUE/255) alpha:1.0];
	//set up four buttons
	self.view.frame = CGRectMake(0, 0, 320, 420);
    int labelHeight = 50;
	CGRect frame = CGRectMake(self.view.frame.origin.x + 1, self.view.frame.origin.y + 1, self.view.frame.size.width/2 - 1, ((self.view.frame.size.height - labelHeight)/2) - 1);
	CGRect labelFrame;
	UIImage *image = [UIImage alloc];
	
	NSMutableString *text = [[NSMutableString alloc] init];
	for (int i = 0; i < 4; i++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = i;
		labelFrame.size.width = frame.size.width;
		labelFrame.size.height = 30;
	
		switch (i) {
			case 0:
			{
				image = [UIImage imageNamed:@"icon_add.png"];
				[text setString: @"New Game"];
				break;
			}
			case 1:
			{
				image = [UIImage imageNamed:@"icon_book_marked.png"];
				frame.origin.x += frame.size.width;
				[text setString:@"Saved Games"];
				break;
			}
			case 2:
			{
				image = [UIImage imageNamed:@"icon_photo.png"];
				frame.origin.x = self.view.frame.origin.x + 1;
				frame.origin.y += frame.size.height;
				[text setString:@"Saved States"];
				break;
			}
			case 3:
			{
				image = [UIImage imageNamed:@"icon_settings.png"];
				frame.origin.x += frame.size.width;
				[text setString:@"Settings"];
				break;
			}

			default:
				break;
		}
		
	
		labelFrame.origin.y = frame.origin.y + 120;
		labelFrame.origin.x = frame.origin.x;
		UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
		[label setText:text];
		[label setTextColor:[UIColor whiteColor]];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFrame:labelFrame];
		[button.layer setBorderWidth:1];
		[button.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
		[button setImage:image forState:UIControlStateNormal];
		//[button setBackgroundColor:[UIColor darkGrayColor]];
        [button setBackgroundColor:buttonColor];
		[button setFrame:frame];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		//[button addSubview:label];
		
		[self.view addSubview:button];
		[self.view addSubview:label];
		//[label release];
		[label release];
		
	}
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton addTarget:self action:@selector(emailMe:) forControlEvents:UIControlEventTouchUpInside];
    [nameButton setFrame:CGRectMake(1, self.view.frame.size.height - labelHeight - 1, 320 - 2 , labelHeight - 4)];
    [nameButton setTitle:@"Created by Sharon Hao" forState:UIControlStateNormal];
    [nameButton setBackgroundColor:[UIColor blackColor]];
    nameButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    nameButton.layer.borderWidth = 1;
    [nameButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [nameButton.titleLabel setTextColor:[UIColor whiteColor]];
    [nameButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:nameButton];
    [buttonColor release];
	
	
	/*
	
	//self.catagories = [[NSArray alloc] initWithObjects:@"Board Setup", @"Pieces", @"Openings", @"Forks, Pins, and Skewers", @"End Game", @"Sample Game", @"Saved States", nil];
	self.catagories = [[NSArray alloc] initWithObjects:@"New Game", @"Saved Games", @"Saved States", @"Settings", nil];
	[self.myTableView reloadData];
	*/
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	//self.myTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
	[self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_SHRINKING]];	
}

- (void)dealloc {
    [super dealloc];
}

-(IBAction) buttonClicked:(id)sender {
	UIButton *tmpButton = sender;

	switch (tmpButton.tag) {
			
		case 0:
		{
			NewGameViewController *targetViewController;
			NSString *viewControllerName = @"NewGameViewController";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			[targetViewController createNewGame];
			[targetViewController setInfoTable];
			
			[targetViewController setTitle:@"New Game"];
    
            
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_grid_white.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
            
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			//viewController = targetViewController;
			//[self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
			[self.navigationController pushViewController:targetViewController animated:YES];

			[targetViewController release];
			break;
		}
		case 1:
		{
			/*
			WatchViewController *targetViewController;
			NSString *viewControllerName = @"WatchViewController";
			
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			[targetViewController setInfoTable];
			//[targetViewController setTmpFilename:@"notation"];
			[self.navigationController pushViewController:targetViewController animated:YES];
			[targetViewController release];
			
			break;
			*/
			SavedGamesTable *targetViewController;
			NSString *viewControllerName = @"SavedGamesTable";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			//targetViewController.parentController = self.navigationController;
			targetViewController.title = @"Saved Games";
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_grid_white.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			[self.navigationController pushViewController:targetViewController animated:YES];
			
			[targetViewController release];
			break;
		}
		case 2:
		{
			/*
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			
			NSData *newData = [prefs objectForKey:@"Saved States"];
			NSArray *newArray = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:newData]];
			NSLog(@"newArray %@", newArray);
			TableViewController *targetViewController;
			NSString *viewControllerName = @"TableViewController";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			targetViewController.tableArray = newArray;
			targetViewController.title = @"Saved States";
			[self.navigationController pushViewController:targetViewController animated:YES];
			[targetViewController release];
			[newArray release];
			*/
			
			SavedStatesTableController *targetViewController;
			NSString *viewControllerName = @"SavedStatesTableController";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			targetViewController.title = @"Saved States";
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_grid_white.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			[self.navigationController pushViewController:targetViewController animated:YES];
		
			[targetViewController release];
			
			break;
		}
		case 3:
		{
			SettingsTableViewController *targetViewController;
			NSString *viewControllerName = @"SettingsTableViewController";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			targetViewController.title = @"Settings";
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_grid_white.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			[self.navigationController pushViewController:targetViewController animated:YES];
			
			[targetViewController release];
			
			break;
		}

		default:
			break;
	}
	
}

-(IBAction)emailMe:(id)sender {
    //MFMailComposeViewController *mf;
    if ([MFMailComposeViewController canSendMail]) {
        //do somtenhig
        
        MFMailComposeViewController *mComposer = [[MFMailComposeViewController alloc] init];
        [mComposer setMailComposeDelegate:self];
        [mComposer setToRecipients:[NSArray arrayWithObject:@"hsharon@mit.edu"]];
        [mComposer setSubject:@"Chess Saver: Questions, comments, concerns.."];
        [mComposer setMessageBody:@"Dear Sharon, \nThis is what I think about your Chess Saver app:" isHTML:NO];
        [self presentModalViewController:mComposer animated:YES];
        
        [mComposer release];
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultSent) {
        //sent
        NSLog(@"email sent");
        
    }
    else if (result == MFMailComposeResultCancelled) {
        //cancelled
        NSLog(@"email cancelled");
        
    }
    else if (result == MFMailComposeResultSaved) {
        //saved
        NSLog(@"email saved");
    }
    else {
        //error?
        NSLog(@"email error?");
    }
    
    
}

-(void)animateTransition:(NSNumber *)duration {
	self.view.userInteractionEnabled=NO;
	[[self view] addSubview:viewController.view];
	if ((viewController.view.hidden==false) && ([duration floatValue]==TIME_FOR_EXPANDING)) {
		viewController.view.frame=[[UIScreen mainScreen] bounds];
		viewController.view.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
	}
	viewController.view.hidden=false;
	if ([duration floatValue]==TIME_FOR_SHRINKING) {
		[UIView beginAnimations:@"animationShrink" context:NULL];
		[UIView setAnimationDuration:[duration floatValue]];
		viewController.view.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
	}
	else {
		[UIView beginAnimations:@"animationExpand" context:NULL];
		[UIView setAnimationDuration:[duration floatValue]];
		viewController.view.transform=CGAffineTransformMakeScale(1, 1);
	}
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
	self.view.userInteractionEnabled=YES;
	if ([animationID isEqualToString:@"animationExpand"]) {
		[[self navigationController] pushViewController:viewController animated:NO];
	}
	else {
		viewController.view.hidden=true;
	}
}



@end
