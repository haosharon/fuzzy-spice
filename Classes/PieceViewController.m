//
//  PieceViewController.m
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PieceViewController.h"


@implementation PieceViewController

@synthesize tmpFilename;
@synthesize tmpMainArray;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		tmpFilename = [NSString alloc];
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:tmpFilename ofType:@"txt"];
	fileArray = [self makeArrayFromFile:path];
	NSLog(@"file array %@", fileArray);
	tmpMainArray = [[NSMutableArray alloc] initWithArray:[self makeArrayFromString:[fileArray objectAtIndex:0]]];
	[self initMainArray:tmpMainArray];
	/*
	 CGRect frame = CGRectMake(260, 60, 40, 20);
	 UIButton *nextMoveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	 [nextMoveButton setFrame:frame];
	 [nextMoveButton setTitle:@"next move" forState:UIControlStateNormal];
	 [nextMoveButton addTarget:self action:@selector(carryOutMove:) forControlEvents:UIControlEventTouchUpInside];
	 [self.view addSubview:nextMoveButton];
	 */
	
	UIToolbar *topToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 44)] autorelease];
	UISegmentedControl *toolbarSegControl;
	if ([fileArray count] > 2) {
		toolbarSegControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Move", @"Capture", @"Promote", nil]] autorelease];
	}
	else {
		toolbarSegControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Move", @"Capture", nil]] autorelease];

	}

	toolbarSegControl.frame = CGRectMake(0, 0, 200, 30);
	toolbarSegControl.segmentedControlStyle = UISegmentedControlStyleBar;
	toolbarSegControl.selectedSegmentIndex = 0;
	[toolbarSegControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *toolbarSegButton = [[[UIBarButtonItem alloc] initWithCustomView:toolbarSegControl] autorelease];
	UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *forward = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(carryOutMove:)] autorelease];
    topToolbar.items = [NSArray arrayWithObjects:spacer, spacer, toolbarSegButton, spacer, forward, nil];
	[self.view addSubview:topToolbar];
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


- (void)dealloc {
    [super dealloc];
}

-(IBAction) segmentValueChanged:(id)sender {
	[self resetBoard];
	
	tmpMainArray = (NSMutableArray *)[self makeArrayFromString:[fileArray objectAtIndex:[sender selectedSegmentIndex]]];
	[self initMainArray:tmpMainArray];
	[self initWithPieces];
	
}


@end
