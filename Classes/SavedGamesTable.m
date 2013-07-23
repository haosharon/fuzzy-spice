//
//  SavedGamesTable.m
//  How To Chess
//
//  Created by Sharon Hao on 7/27/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "SavedGamesTable.h"
#import "WatchViewController.h"
#import "NewGameViewController.h"
#import "SavedGameCell.h"
#import "Game.h"


@implementation SavedGamesTable

@synthesize parentController;
@synthesize savedGames;
@synthesize savedGameIDs;

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
	//NSMutableArray *newArray = [[NSMutableArray alloc] init];
	if ([NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Saved Games"]]) {
		savedGames = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Saved Games"]]];
	}
	else {
		savedGames = [[NSMutableArray alloc] init];
		
	}
	
	if ([prefs objectForKey:@"Saved Game IDs"]) {
		savedGameIDs = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"Saved Game IDs"]];
	}
	else {
		savedGameIDs = [[NSMutableArray alloc] init];
	}
    [self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:savedGames];
	[prefs setObject:theData forKey:@"Saved Games"];
	[prefs setObject:savedGameIDs forKey:@"Saved Game IDs"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2; //section 1: list of saved games, section 2: create new game
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return [savedGames count];
	}
	else {
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

	switch (indexPath.section) {
		case 0:
		{    
            static NSString *CellIdentifier = @"SavedGameCell";
            
            SavedGameCell *cell = (SavedGameCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SavedGameCell" owner:nil options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[SavedGameCell class]]) {
                        cell = (SavedGameCell *)currentObject;
                        break;
                    }
                }
            }
			Game *tmpGame = [savedGames objectAtIndex:indexPath.row];
			//[cell.textLabel setText:[tmpGame.gameInfo objectForKey:@"Date"]];
			[[cell titleLabel] setText:[NSString stringWithFormat:@"%@ vs. %@", [tmpGame.gameInfo objectForKey:@"White"], [tmpGame.gameInfo objectForKey:@"Black"]]];
			[[cell dateLabel] setText:[tmpGame.gameInfo objectForKey:@"Date"]];
			//[cell.titleLabel setText:[tmpGame.gameInfo objectForKey:@"Date"]];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return cell;
			break;
		}
		case 1:
		{
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
			[cell.textLabel setText:@"Create New Game"];
			[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
            return cell;
			break;
		}

		default:
			break;
	}
    
	
    // Configure the cell...
    
    //return cell;
    return nil;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (indexPath.section == 0) {
		return YES;
	}
	else {
		return NO;
	}

}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		[savedGames removeObjectAtIndex:indexPath.row];
		[savedGameIDs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:savedGames];
        [prefs setObject:theData forKey:@"Saved Games"];
        [prefs setObject:savedGameIDs forKey:@"Saved Game IDs"];
		//[savedGames removeObjectAtIndex:indexPath.row];
		
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0:
		{
			
			WatchViewController *targetViewController;
			NSString *viewControllerName = @"WatchViewController";
			Game *tmpGame = [savedGames objectAtIndex:indexPath.row];
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			targetViewController.watchGame = tmpGame;
			targetViewController.movesArray = [[NSMutableArray alloc] initWithArray:tmpGame.movesArray];
			[targetViewController setInfoTableWithGame:tmpGame];
			[targetViewController setTitle:[NSString stringWithFormat:@"%@ vs. %@", [tmpGame.gameInfo objectForKey:@"White"], [tmpGame.gameInfo objectForKey:@"Black"]]];
			
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_list.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			
			[self.navigationController pushViewController:targetViewController animated:YES];
			[targetViewController setUpPiecesRegular];
			[targetViewController release];
			
			break;
		}
		case 1:
		{
            /*
			NewGameViewController *targetViewController;
			NSString *viewControllerName = @"NewGameViewController";
			UINavigationController *navController = self.navigationController;
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];

			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_list"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController
																		  action:@selector(goBack:)];
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			//[navController popToRootViewControllerAnimated:NO];
			[navController pushViewController:targetViewController animated:YES];
            [targetViewController createNewGame];
			[targetViewController setInfoTable];
			[targetViewController release];
			
			break;
            */
            NewGameViewController *targetViewController;
			NSString *viewControllerName = @"NewGameViewController";
			targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
			[targetViewController createNewGame];
			[targetViewController setInfoTable];
			
			[targetViewController setTitle:@"New Game"];
            
            
			UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_list.png"] 
																		   style:UIBarButtonItemStyleBordered 
																		  target:targetViewController 
																		  action:@selector(goBack:)];
            
			targetViewController.navigationItem.leftBarButtonItem = leftButton;
			[leftButton release];
			//viewController = targetViewController;
			//[self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
            //[self.navigationController popToRootViewControllerAnimated:NO];
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
}


@end

