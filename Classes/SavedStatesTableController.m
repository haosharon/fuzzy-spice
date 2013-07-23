//
//  SavedStatesTableController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/29/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "SavedStatesTableController.h"
#import "BoardState.h"
#import "PlayViewController.h"
#import "CustomSetUpViewController.h"



@implementation SavedStatesTableController

@synthesize parentController;
@synthesize savedStates, savedStateIDs;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    const float RED = 100;
    const float GREEN = 0;
    const float BLUE = 0;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:RED/255 green:GREEN/255 blue:BLUE/255 alpha:1.0]];

	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if ([prefs objectForKey:@"Saved State IDs"]) {
        savedStateIDs = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"Saved State IDs"]];
        savedStates = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Saved States"]]];
    }

	else {
		savedStates = [[NSMutableArray alloc] init];
        savedStateIDs = [[NSMutableArray alloc] init];
	}
	NSLog(@"saved states %@", savedStates);
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    /*
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:savedStates];
    [prefs setObject:savedStateIDs forKey:@"Saved State IDs"];
	[prefs setObject:theData forKey:@"Saved States"];*/
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return [savedStates count];
	}
	else {
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	switch (indexPath.section) {
		case 0:
		{
			BoardState *tmpState = [savedStates objectAtIndex:indexPath.row];
			[cell.textLabel setText:[tmpState.stateInfo objectForKey:@"Title"]];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[cell.textLabel setTextAlignment:UITextAlignmentLeft];
			break;
		}
		case 1:
		{
			[cell.textLabel setText:@"Create New State"];
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
			break;
		}
		default:
			break;
	}
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (indexPath.section == 1 || indexPath.row == 0) {
		return NO;
	}
	else {
		return YES;
	}

}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		[savedStates removeObjectAtIndex:indexPath.row];
        [savedStateIDs removeObjectAtIndex:indexPath.row];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:savedStates];
        [prefs setObject:savedStateIDs forKey:@"Saved State IDs"];
        [prefs setObject:theData forKey:@"Saved States"];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	switch (indexPath.section) {
		case 0:
		{
			PlayViewController *targetViewController;
			NSString *viewControllerName = @"PlayViewController";
			BoardState *tmpState = [savedStates objectAtIndex:indexPath.row];
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			
			targetViewController.movesArray = [[NSMutableArray alloc] init];
			[targetViewController setInfoTableWithState:tmpState];
			[targetViewController setTitle:[tmpState.stateInfo objectForKey:@"Title"]];
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_list.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			[self.navigationController pushViewController:targetViewController animated:YES];
			[targetViewController setUpPiecesFromState:tmpState];
			targetViewController.whiteToMove = tmpState.whiteToMove;
            if (!targetViewController.whiteToMove) {
                [targetViewController addMoveToComments:nil];
            }
			
			[targetViewController release];
			
			break;
		}
		case 1:
		{
			CustomSetUpViewController *targetViewController;
			NSString *viewControllerName = @"CustomSetUpViewController";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_list.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
            [targetViewController createNewState];
            [targetViewController setInfoTable];
			[self.navigationController pushViewController:targetViewController animated:YES];
			[targetViewController release];
			break;
		}
		default:
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	self.parentController = nil;
	self.savedStates = nil;
}


@end

