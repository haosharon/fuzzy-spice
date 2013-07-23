//
//  SetupViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/13/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "SetupViewController.h"


@implementation SetupViewController

@synthesize tmpFilename;
@synthesize fileArray;
@synthesize tmpMainArray;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		tmpFilename = [NSString alloc];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	/*
	NSString *path = [[NSBundle mainBundle] pathForResource:tmpFilename ofType:@"txt"];
	fileArray = [self makeArrayFromFile:path];
	tmpMainArray = [[NSMutableArray alloc] initWithArray:[self makeArrayFromString:[fileArray objectAtIndex:0]]];
	[self initMainArray:tmpMainArray];	
	 */
    [super viewDidLoad];
	[self setUpPiecesRegular];
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


@end
