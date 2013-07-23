//
//  WatchViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/25/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "WatchViewController.h"
#import "SavedGamesTable.h"

@implementation WatchViewController


@synthesize watchGame;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.

    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	/*
	filename = tmpFilename;
	gameNotation = [[Notation alloc] init];
	[gameNotation setFileName:filename];
	[gameNotation initialize];
	movesArray = [[NSArray alloc] initWithArray:[gameNotation getMovesArray]];
	*/
	


	//infoTable.gameInfo = [gameNotation getInfoArray];

	
	//NSString *path = [[NSBundle mainBundle] pathForResource:tmpFilename ofType:@"txt"];
	//fileArray = [self makeArrayFromFile:path];

	
	
	
	//UIToolbar *topToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 44)] autorelease];
	//[forward release];
	//topToolbar.items = [NSArray arrayWithObjects:forward, nil];
	//[self.view addSubview:topToolbar];
    [super viewDidLoad];

	//[self setUpPiecesRegular];
	[self setUpTextandButtons];
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

-(IBAction)optionsAction:(id)sender {
    //this will be overridden
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Flip Board", nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet setTag:1];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

-(void) setInfoTableWithGame:(Game *)game {
	infoTable = [[InfoTableController alloc] init];
	infoTable.parentController = self;
	//infoTable.gameInfo = info;
	infoTable.gameInfo = [[NSMutableDictionary alloc] initWithDictionary:game.gameInfo];
    infoTable.game = game;
	//movesArray = [[NSMutableArray alloc] initWithArray:watchGame.movesArray];
}

-(void) setInfoTableWithState:(BoardState *)state {
    infoTable = [[InfoTableController alloc] init];
    infoTable.parentController = self;
    infoTable.state = state;
}


@end
