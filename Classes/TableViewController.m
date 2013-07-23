//
//  TableViewController.m
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "PieceViewController.h"
#import "PlayViewController.h"
#import "BoardState.h"
#import "CustomSetUpViewController.h"
#import "BoardViewController.h"


@implementation TableViewController

@synthesize myTableView;
@synthesize tableArray;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		//tableArray = [NSArray alloc];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self.myTableView reloadData];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
	[self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:NO];
}


- (void)dealloc {
    [super dealloc];
}

- (void)setArrayWithString:(NSString *)filename {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
	NSString *string = [[NSString alloc] initWithContentsOfFile:filePath];
	tableArray = [[NSArray alloc] initWithArray:[string componentsSeparatedByString:@"\n"]];
	[string release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return [tableArray count];
			break;
		case 1:
			return 1;
			break;

		default:
			return 1;
			break;
	}
	
	//return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellIdentifier = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (!cell)
	{
		if (indexPath.section == 0) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if ([self.title isEqual:@"Saved States"]) {
				cell.textLabel.text = [((BoardState *)[tableArray objectAtIndex:indexPath.row]).stateInfo objectForKey:@"Title"];
			}
			else {
				cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
				
			}
			
		}
		else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.text = @"Create a New Game";
		}
        cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.opaque = NO;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.highlightedTextColor = [UIColor whiteColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
		
		cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.opaque = NO;
		cell.detailTextLabel.textColor = [UIColor grayColor];
		cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
	if (indexPath.section == 0) {
			}
	else {
		
	}

	//


	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	

	if ([self.title isEqual:@"Openings"]) {
		/*
		selected = [[NSString alloc] initWithString:[tableArray objectAtIndex:indexPath.row]];
		PlayViewController *targetViewController;
		viewControllerName = @"PlayViewController";
		
		targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
		[targetViewController setTitle:selected];
		[targetViewController setTmpFilename:selected];
		[self.navigationController pushViewController:targetViewController animated:YES];
		[targetViewController release];
		*/
	}
	else if ([self.title isEqual:@"Saved States"]) {
		switch (indexPath.section) {
			case 0: {
				BoardViewController *targetViewController;
				NSString *viewControllerName = @"BoardViewController";
				targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
				[targetViewController setTitle:@"New Game"];
				[self.navigationController pushViewController:targetViewController animated:YES];
				[targetViewController setUpPiecesRegular];

				[targetViewController release];
				break;
			}
			case 1: {
				
				CustomSetUpViewController *targetViewController;
				NSString *viewControllerName = @"CustomSetUpViewController";
				targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
				[self.navigationController pushViewController:targetViewController animated:YES];
				[targetViewController release];
				break;
			}
			default:
				break;
		}

		
	}


	
	
}




@end
