//
//  NewGameViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/27/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "NewGameViewController.h"


@implementation NewGameViewController

@synthesize newGame;

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
	//[self createNewGame];
    [super viewDidLoad];
    infoTable.parentController = self;
	[self setUpPiecesRegular];
	//self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(exitAction:)];

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


- (void)dealloc {
    [super dealloc];
}

- (void) createNewGame {
	newGame = [[Game alloc] init];
	//newGame.gameInfo = [newGame.gameInfo init];
	//newGame.movesArray = [newGame.movesArray init];
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSLog(@"date %@", [dateFormatter stringFromDate:now]);
	[newGame.gameInfo setObject:[dateFormatter stringFromDate:now] forKey:@"Date"];
	[dateFormatter release];
	[newGame.gameInfo setObject:@"" forKey:@"White"];
	[newGame.gameInfo setObject:@"" forKey:@"Black"];
	[newGame.gameInfo setObject:@"unknown" forKey:@"Result"];
	[newGame assignGameID];
}

- (void) setInfoTable {
	infoTable = [[InfoTableController alloc] init];
	infoTable.parentController = self;
	NSLog(@"infotable class %@", [infoTable class]);
	infoTable.gameInfo = [[NSMutableDictionary alloc] initWithDictionary:newGame.gameInfo];
    infoTable.game = newGame;
    NSLog(@"game %@", newGame);
	movesArray = [[NSMutableArray alloc] init];
    
    newGame.movesArray = movesArray;
    
	
}

- (void) gameIsOver:(char)result {
    newGame.result = result; 
    
}


-(IBAction) goBack:(id)sender {
    //if game is unsaved, let user know they will lose data
    [newGame release];
	[self.navigationController popViewControllerAnimated:YES];
}





- (IBAction) saveGame:(id)sender {
	
	//[newGame.movesArray setArray:movesArray];
	[newGame.gameInfo setDictionary:infoTable.game.gameInfo];
    if (infoTable.activeView) {
        [newGame.comments setString:infoTable.activeView.text];
    }
    else {
        [newGame.comments setString:infoTable.comments];
    }
	BOOL saved = NO;

	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *savedGamesArray;	
	NSMutableArray *savedGameIDs;
	NSString *alertMessage;
	
	if ([prefs arrayForKey:@"Saved Game IDs"]) {
		
		savedGameIDs = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"Saved Game IDs"]];
		savedGamesArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Saved Games"]]];
		
		/*
		to empty data (testing)
		savedGameIDs = [[NSMutableArray alloc] init];
		savedGamesArray = [[NSMutableArray alloc] init];
		 */
		///check if game id already exists - this means the game was already saved, and we need to save changes
		for (int i = 0; i < [savedGameIDs count]; i ++) {
			if ([newGame.gameID isEqualToString:[savedGameIDs objectAtIndex:i]]) {
				NSLog(@"newgame ID %@", newGame.gameID);
				[savedGameIDs replaceObjectAtIndex:i withObject:newGame.gameID];
				[savedGamesArray replaceObjectAtIndex:i withObject:newGame];
				alertMessage = [[NSString alloc] initWithString:@"Changes saved!"];
				saved = YES;
			}
		}
		if (!saved) {
			[savedGamesArray addObject:newGame];
			[savedGameIDs addObject:newGame.gameID];
			alertMessage = [[NSString alloc] initWithString:@"Game saved!"];
			saved = YES;
		}
	}
	else {
		savedGameIDs = [[NSMutableArray alloc] initWithObjects:newGame.gameID, nil];
		savedGamesArray = [[NSMutableArray alloc] initWithObjects:newGame, nil];
		alertMessage = [[NSString alloc] initWithString:@"Game saved!"];
	}
	
	NSData *theData =[NSKeyedArchiver archivedDataWithRootObject:savedGamesArray];
	[prefs setObject:theData forKey:@"Saved Games"]; 
	[prefs setObject:savedGameIDs forKey:@"Saved Game IDs"];
	
	///add alert, game saved
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Game" 
													message:alertMessage 
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[alertMessage release];
	
        
    [self.navigationController popViewControllerAnimated:YES];
    
	return;
	

}




- (IBAction) exitAction:(id)sender {
	NSLog(@"hi");
}


@end
