//
//  BoardSetupViewController.m
//  How To Chess
//
//  Created by Weaver Mobile MacbookPro 1 on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoardSetupViewController.h"

const int SQUARE_SIZE = 35;

@implementation BoardSetupViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization.
		return nil;
    }
	
	self.title = @"Board Setup";
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	white = YES;
	black = NO;
	squareDict = [[NSMutableDictionary alloc] initWithCapacity:64];
	NSArray *objects = [[[NSArray alloc] initWithObjects:@"pawn", @"rook", @"knight", @"bishop", @"queen", @"king", nil] autorelease];
	NSArray *keys = [[[NSArray alloc] initWithObjects:@"P", @"R", @"K", @"B", @"Q", @"K", nil] autorelease];
	piecesDict = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
	[self buildBoard];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"chess" ofType:@"txt"];
	
	NSArray *fileArray = [self makeArrayFromFile:path];
	
	NSLog(@"file array %@", fileArray);
	
	NSArray *array = [[NSArray alloc] initWithArray:[self makeArrayFromString:[fileArray objectAtIndex:0]]];
	
	[self addPieces:[array objectAtIndex:2] color:white];
	[self addPieces:[array objectAtIndex:3] color:black];
	
												
	
	//[array release];
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

- (NSArray *) makeArrayFromFile:(NSString *)filePath {
	NSString *fileString = [[NSString alloc] initWithContentsOfFile:filePath];
	NSArray *array = [[NSArray alloc] initWithArray:[fileString componentsSeparatedByString:@"\n"]];
	NSLog(@"print array %@", array);
	return array;
	
	
}

- (NSArray *) makeArrayFromString:(NSString *)string {
	NSArray *array = [[[NSArray alloc] initWithArray:[string componentsSeparatedByString:@","]] autorelease];
	return array;
}

- (void)buildBoard {
	int start_x = (320 - 8*SQUARE_SIZE)/2;
	int start_y = self.view.frame.size.height - 44 - 8*SQUARE_SIZE - (320 - 8*SQUARE_SIZE)/2;
	for (int x = 0; x < 8; x ++) {
		int i = (int)'A' + x;
		char c = (char)i;
		for (int y = 0; y < 8; y ++) {
			NSMutableString *notation = [[NSMutableString alloc] initWithFormat:@"%c%d", c, 8 -y];
			UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(start_x + x*SQUARE_SIZE, start_y + y*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)];
			if ((x - y)%2 == 0) {
				[iv setBackgroundColor:[UIColor whiteColor]];
			}
			else {
				[iv setBackgroundColor:[UIColor lightGrayColor]];
			}
			[squareDict setObject:iv forKey:notation];
			[self.view addSubview:iv];
			//[notation release];

			
		}
	}
	
}

- (void)addPieces:(NSString *)pieces color:(BOOL)color {
	if ([pieces length]%3 > 0) {
		//error
		NSLog(@"error %@", [pieces length]);
	}
	else {
		NSString *prefix;
		if (color == white) {
			prefix = [[[NSString alloc] initWithString:@"w_"] autorelease];
		}
		else {
			prefix = [[[NSString alloc] initWithString:@"b_"] autorelease];
		}
		
		for (int i = 0; i < [pieces length]; i += 3) {
			NSString *piece = [[[NSString alloc] initWithString:[pieces substringWithRange:NSMakeRange(i, 1)]] autorelease] ;
			NSString *notation = [pieces substringWithRange:NSMakeRange(i + 1, 2)];
			NSString *pieceName = [[[NSString alloc] initWithString:[piecesDict objectForKey:piece]] autorelease];
			NSString *fileName = [[[NSString alloc] initWithFormat:@"%@%@.png", prefix, pieceName] autorelease];
			NSLog(@"filename %@", fileName);
			UIImage *pieceImage = [UIImage imageNamed:fileName];
			NSLog(@"notation %@", notation);
			[(UIImageView *)[squareDict objectForKey:notation] setImage:pieceImage];
			
		}

		
		
		
		
		
	}

	
	
	
	
	
}

@end
