//
//  CustomSetUpViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/20/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "CustomSetUpViewController.h"
#import "Piece.h"
#import "BoardState.h"

const int SQUARE_SIZ = 37;


@implementation CustomSetUpViewController

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
    [super viewDidLoad];
    /*
	UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(askForStateTitle)];
	self.navigationItem.rightBarButtonItem = rButton;
	[rButton release];
    */
	
	piecesArray = [[NSMutableArray alloc] initWithCapacity:12];
	activeIV = [UIImageView alloc];
	[activeIV setHidden:YES];
	[self.view addSubview:activeIV];
	imageIV = [[UIImageView alloc] init];
	[self.view addSubview:imageIV];
	[activeIV setUserInteractionEnabled:YES];
	//activePiece = [[Piece alloc] init];
    activePiece = [[Piece alloc] init];

	nameArray = [[NSArray alloc] initWithObjects:@"P", @"R", @"N", @"B", @"Q", @"K", nil];
	setupPieces = [[NSMutableArray alloc] initWithCapacity:64];
	stateInfo = [[NSMutableDictionary alloc] init];
	[stateInfo setObject:@"Test State" forKey:@"Title"];
	
    
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	[stateInfo setObject:[dateFormatter stringFromDate:now] forKey:@"Date"];
	[dateFormatter release];
	
	[self setUpSidePieces];
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
	activeIV = nil;
	imageIV = nil;
	piecesArray = nil;
}

- (BOOL) stateIsValid {
    //both colors must have exactly 1 king
    //both colors can't have more than 8 pawns
    int numKings = 0;
    int numPawns = 0;
    Piece *tmpPiece;
    for (int i = 0; i < [whitePieces count]; i ++) {
        tmpPiece = [whitePieces objectAtIndex:i];
        if ([tmpPiece.name isEqualToString:@"P"]) {
            numPawns ++;
        }
        else if ([tmpPiece.name isEqualToString:@"K"]) {
            numKings ++;
        }
    }
    if (numKings != 1 || numPawns > 8) {
        return NO;
    }
    numKings = 0;
    numPawns = 0;
    for (int i = 0; i < [blackPieces count]; i ++) {
        tmpPiece = [blackPieces objectAtIndex:i];
        if ([tmpPiece.name isEqualToString:@"P"]) {
            numPawns ++;
        }
        else if ([tmpPiece.name isEqualToString:@"K"]) {
            numKings ++;
        }
    }
    if (numKings != 1 || numPawns > 8) {
        return NO;
    }
  
    if ([self isInCheck:!newState.whiteToMove withMove:nil]) {
        return NO;
    }
    
    
    return YES;
}


-(void)saveBoardStateAction {	
    if (![self stateIsValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"State is not valid" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    else {
        if ([[newState.stateInfo objectForKey:@"Title"] length] <= 0) {
            [self askForStateTitle];
        }
        else {
            [self saveBoardState];
        }
    }
 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];

	//if drags a piece from side
	for (int i = 0; i < [piecesArray count]; i++) {
		//UIImageView *tmpIV = [[UIImageView alloc] init];
		UIImageView *tmpIV = [piecesArray objectAtIndex:i];
		if ([touch view] == tmpIV) {

			[activePiece.name setString:[nameArray objectAtIndex:i%6]];
			activePiece.white = (i <=5);
			activeIV = tmpIV;
			[imageIV setFrame:tmpIV.frame];
			[imageIV setImage:tmpIV.image];
			[imageIV setHidden:NO];
			/*
			activeIV.frame = tmpIV.frame;
			activeIV.image = tmpIV.image;
			*/
			[self.view bringSubviewToFront:imageIV];
			return;
			
			
		}
	}
	//if edit piece on board
	for (int i = 0; i < [squareDict count]; i++) {
		//NSString *key = [[NSString alloc] initWithString:[[squareDict allKeys] objectAtIndex:i]];
		NSString *key = [[squareDict allKeys] objectAtIndex:i];
		//UIImageView *tmpIV = [[[UIImageView alloc] init] autorelease];
		UIImageView *tmpIV = [squareDict objectForKey:key];
		if ([touch view] == tmpIV) {
			if (tmpIV.image) {
				for (int p = 0; p < [blackPieces count]; p ++) {
					Piece *tmpPiece = [blackPieces objectAtIndex:p];
					if ([key isEqual:tmpPiece.square]) {
						[activePiece.name setString:tmpPiece.name];
						activePiece.white = tmpPiece.white;
						[blackPieces removeObjectAtIndex:p];
                        break;
					}
				}
                for (int p = 0; p < [whitePieces count]; p ++) {
                    Piece *tmpPiece = [whitePieces objectAtIndex:p];
					if ([key isEqual:tmpPiece.square]) {
						[activePiece.name setString:tmpPiece.name];
						activePiece.white = tmpPiece.white;
						[whitePieces removeObjectAtIndex:p];
                        break;
					}
                }
				
				activeIV = tmpIV;
				
				[imageIV setFrame:tmpIV.frame];
				[imageIV setImage:tmpIV.image];
				[tmpIV setImage:nil];
				[imageIV setHidden:NO];
				[self.view bringSubviewToFront:imageIV];
				return;
			}
			
		}
	}
	 
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch view] == activeIV) {
		CGPoint location = [touch locationInView:self.view];
		imageIV.center = location;
		return;
	}
  
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSString *key = [self closestSquareToPoint:[touch locationInView:self.view]];
	if ([touch view] == activeIV) {
		if ([key isEqual:@"none"]) {
			NSLog(@"not in board");
			[imageIV setHidden:YES];
		}
		else if (key) {
			NSLog(@"key %@", key);
			UIImageView *tmpIV = [squareDict objectForKey:key];
			[tmpIV setImage:imageIV.image];
			[imageIV setHidden:YES];
			[activePiece.square setString:key];
            Piece *newPiece = [[Piece alloc] init];
            [newPiece setPieceWithPiece:activePiece];
			[setupPieces addObject:newPiece];
            if (newPiece.white) {
                [whitePieces addObject:newPiece];
            }
            else {
                [blackPieces addObject:newPiece];
            }
            [newPiece release];
		}
	}
	
	
	
	
}

- (NSString *)closestSquareToPoint:(CGPoint)point {
	for (int i = 0; i < [squareDict count]; i++) {
		NSString *tmpKey = [[squareDict allKeys] objectAtIndex:i];
		UIImageView *tmpIV = [squareDict objectForKey:tmpKey];
		if (CGRectContainsPoint(tmpIV.frame, point)) {
			return tmpKey;
		}
	}
	
	return @"none";

	
}


-(void) setUpSidePieces {
	
	
	int start_x = (320 - 8*SQUARE_SIZ)/2;
	//int start_x = 25;
	int start_y = 10;
    float spacing = (320 - 6*SQUARE_SIZ)/7;
	BOOL color = YES;
	for (int i = 0; i < 2; i ++) {
		
		for (int p = 0; p < [nameArray count]; p++) {
			Piece *tmpPiece = [[Piece alloc] init];
			[tmpPiece.name setString:[nameArray objectAtIndex:p]];
			tmpPiece.white = color;
			UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(start_x + p*(SQUARE_SIZ + spacing), start_y,SQUARE_SIZ , SQUARE_SIZ)];
			[iv setImage:[tmpPiece getPieceImage]];
			[iv setUserInteractionEnabled:YES];
			[self.view addSubview:iv];
			[piecesArray addObject:iv];
			[tmpPiece release];
		}
		start_y += SQUARE_SIZ + spacing;
		color = NO;
	}
	
	
	
	
	
}

-(void) createNewState {
    newState = [[BoardState alloc] init];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    [newState.stateInfo setObject:[dateFormatter stringFromDate:now] forKey:@"Date"];
    [dateFormatter release];
    [newState.stateInfo setObject:@"" forKey:@"Title"];
    //[newState.stateInfo setObject:newState.whiteToMove?@"Yes":@"No" forKey:@"Next Move"];
    [newState assignStateID];

    
}
-(void) setInfoTable {
    infoTable = [[InfoTableController alloc] init];
    infoTable.parentController = self;
    infoTable.state = newState;
    infoTable.newState = YES;
    
    
}



-(void) saveBoardState {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *savedStatesArray;
	[newState.piecesArray addObjectsFromArray:whitePieces];
	[newState.piecesArray addObjectsFromArray:blackPieces];
    if (infoTable.activeView) {
        [newState.comments setString:self.infoTable.activeView.text];
    }
    else {  
        NSLog(@"comments %@", self.infoTable.comments);
        [newState.comments setString:self.infoTable.comments];
    }
	newState.stateID = [[NSString alloc] initWithString:[newState getRandomNumber]];
	
    if ([[newState.stateInfo objectForKey:@"Title"] length] <= 0) {
        [newState.stateInfo setObject:stateTitleTextField.text forKey:@"Title"];

    }
    //[newState.stateInfo setObject:newState.whiteToMove?@"Yes":@"No" forKey:@"Next Move"];
	
	NSMutableArray *savedStateIDs;
	if ([prefs objectForKey:@"Saved State IDs"]) {
		savedStateIDs = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"Saved State IDs"]];
		savedStatesArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Saved States"]]];
		[savedStatesArray addObject:newState];
		[savedStateIDs addObject:newState.stateID];
	}
	else {
		savedStateIDs = [[NSMutableArray alloc] initWithObjects:newState.stateID, nil];
		savedStatesArray = [[NSMutableArray alloc] initWithObjects:newState, nil];
	}
	[prefs setObject:savedStateIDs forKey:@"Saved State IDs"];
	NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:savedStatesArray];
	[prefs setObject:theData forKey:@"Saved States"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New State" 
													message:@"State saved!" 
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
    [self.navigationController popViewControllerAnimated:YES];
	
}






@end
