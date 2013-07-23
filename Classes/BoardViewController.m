//
//  BoardViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/13/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BoardViewController.h"
#import "Notation.h"
#import "Piece.h"
#import "Move.h"
#import "InfoViewController.h"
#import "InfoTableController.h"


const int SQUARE_SIZE = 37;


const float BACK_RED = 100;
const float BACK_GREEN = 0;
const float BACK_BLUE = 0;


@implementation BoardViewController

@synthesize filename;
@synthesize infoTable;
@synthesize movesArray;
@synthesize stateTitleTextField;
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


    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    soundIsOn = ![prefs boolForKey:@"soundOff"];
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[info setContentEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
	[info addTarget:self action:@selector(getInfo:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:info];
	
	self.navigationItem.rightBarButtonItem = infoButton;
    [infoButton release];
    
	CGRect frame =	CGRectMake(0, 0, 320, 480);
	infoTable.view.frame = frame;
    //infoTable.parentController = self;
	[self.view addSubview:infoTable.view];
	[self.view sendSubviewToBack:infoTable.view];
	[self.infoTable.view setHidden:YES];
	isBoardFlipped = NO;
	
	stateTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	[stateTitleTextField setBackgroundColor:[UIColor whiteColor]];
	[stateTitleTextField setPlaceholder:@"Required"];
	backColor = [[UIColor alloc] initWithRed:BACK_RED/255 green:BACK_GREEN/255 blue:BACK_BLUE/255 alpha:1.0];
	[self.view setBackgroundColor:backColor];
	white = YES;
	black = NO;
	squareDict = [[NSMutableDictionary alloc] initWithCapacity:64];
	NSArray *objects = [[[NSArray alloc] initWithObjects:@"pawn", @"rook", @"knight", @"bishop", @"queen", @"king", nil] autorelease];
	NSArray *keys = [[[NSArray alloc] initWithObjects:@"P", @"R", @"N", @"B", @"Q", @"K", nil] autorelease];
	piecesDict = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
	whitePieces = [[NSMutableArray alloc] initWithCapacity:16];
	blackPieces = [[NSMutableArray alloc] initWithCapacity:16];
	whiteTaken = [[NSMutableArray alloc] initWithCapacity:16];
	blackTaken = [[NSMutableArray alloc] initWithCapacity:16];
	movesMade = [[NSMutableArray alloc] init];
	[self buildBoard];
	//[self setUpText];
	
	moveCount = 0;
	whiteMove = YES;
	
	//[self setUpPiecesRegular];
	
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
	[filename release];
	[movesArray release];
    [super dealloc];
}

-(IBAction) goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


/*
- (void) initFilename:(NSString *)string {
	filename = [[NSString alloc] initWithString:string];
}	
*/

/*
- (void) initMainArray:(NSArray *)array {
	mainArray = [[NSMutableArray alloc] initWithArray:array];
	NSString *string = [[[NSString alloc] initWithString:[mainArray objectAtIndex:2]] autorelease];
	movesArray = [[NSArray alloc] initWithArray:[string componentsSeparatedByString:@" "]];
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
*/

-(void) flipBoard {
    
    //unhighlight last move
    if ([movesMade count] > 0) {
        [self unhighlightSquare:((Move *)[movesMade lastObject]).endSquare];
        [self unhighlightSquare:((Move *)[movesMade lastObject]).startSquare];
    }
    
    
    NSMutableString *tmpSquare;
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithCapacity:64];
    char row;
    char col;
    for (int i = 0; i < 64; i++) {
        NSMutableString *newSquare = [[NSMutableString alloc] initWithCapacity:2];
        tmpSquare = [[squareDict allKeys] objectAtIndex:i];
        row = [tmpSquare characterAtIndex:1];
        col = [tmpSquare characterAtIndex:0];
        row = ('1' + '8') - row;
        col = ('a' + 'h') - col;
        [newSquare setString:[NSString stringWithFormat:@"%c%c", col, row]];
        [newDict setObject:[squareDict objectForKey:tmpSquare] forKey:newSquare];
        
    }
    [squareDict setDictionary:newDict];
    [newDict release];
    
    //flip letter and num labels
    UILabel *letLabel, *numLabel;
    for (int i = 0; i < 8; i ++) {
        letLabel = [letLabels objectAtIndex:i];
        col = [letLabel.text characterAtIndex:0];
        numLabel = [numLabels objectAtIndex:i];
        row = [numLabel.text characterAtIndex:0];
        col = 'A' + 'H' - col;
        row = '1' + '8' - row;
        [letLabel setText:[NSString stringWithFormat:@"%c", col]];
        [numLabel setText:[NSString stringWithFormat:@"%c", row]];
    }
    
    //clear board
    [self clearBoard];
    
    //set up board again
    BoardState *currentState = [[BoardState alloc] init];
    [currentState.piecesArray addObjectsFromArray:whitePieces];
    [currentState.piecesArray addObjectsFromArray:blackPieces];
    [self setUpPiecesFromState:currentState];
    [currentState release];
    
    //highlight last move
    if ([movesMade count] > 0) {
        [self highlightSquare:((Move *)[movesMade lastObject]).endSquare withColor:[UIColor yellowColor]];
        [self highlightSquare:((Move *)[movesMade lastObject]).startSquare withColor:[UIColor yellowColor]];
    }

}

-(void) clearBoard {
    for (int i = 0; i < 64; i ++) {
        ((UIImageView *)[[squareDict allValues] objectAtIndex:i]).image = nil;
    }
}



- (void)buildBoard {
	//int start_x = (320 - 8*SQUARE_SIZE)/2;
    int start_x = 16;
	int start_y = self.view.frame.size.height - 44 - 8*SQUARE_SIZE - start_x;
	for (int x = 0; x < 8; x ++) {
		int i = (int)'a' + x;
		char c = (char)i;
		for (int y = 0; y < 8; y ++) {
			NSMutableString *notation = [[NSMutableString alloc] initWithFormat:@"%c%d", c, 8 -y];
			UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(start_x + x*SQUARE_SIZE, start_y + y*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)];
			UIImageView *backIV = [[UIImageView alloc] initWithFrame:CGRectMake(start_x + x*SQUARE_SIZE, start_y + y*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)];
			[iv setBackgroundColor:[UIColor clearColor]];
			if ((x - y)%2 == 0) {
				[backIV setBackgroundColor:[UIColor whiteColor]];
			}
			else {
				[backIV setBackgroundColor:[UIColor lightGrayColor]];
			}
			[squareDict setObject:iv forKey:notation];
			[iv setUserInteractionEnabled:YES];
			[self.view addSubview:backIV];
			[self.view addSubview:iv];
			[self.view bringSubviewToFront:iv];
			[backIV release];
		}
	}
	
	//add notations
    numLabels = [[NSMutableArray alloc] initWithCapacity:8];
    letLabels = [[NSMutableArray alloc] initWithCapacity:8];
	for (int i = 0; i < 8; i++) {
		UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, start_y + i*SQUARE_SIZE, start_x - 2, SQUARE_SIZE)];
		UILabel *letLabel = [[UILabel alloc] initWithFrame:CGRectMake(start_x + i*SQUARE_SIZE, self.view.frame.size.height - 44 - start_x, SQUARE_SIZE, start_x)];
		[letLabel setTextAlignment:UITextAlignmentCenter];
		[numLabel setTextAlignment:UITextAlignmentLeft];
		[letLabel setContentMode:UIViewContentModeBottom];
		[numLabel setText:[NSString stringWithFormat:@"%d",8 - i]];
		char c = (char)((int)'A' + i);
		[letLabel setText:[NSString stringWithFormat:@"%c", c]];
		[numLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		[letLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];

		[numLabel setBackgroundColor:[UIColor clearColor]];
		[letLabel setBackgroundColor:[UIColor clearColor]];
		[numLabel setTextColor:[UIColor whiteColor]];
		[letLabel setTextColor:[UIColor whiteColor]];
		[self.view addSubview:numLabel];
		[self.view addSubview:letLabel];
		//[numLabel release];
		//[letLabel release];
        [numLabels addObject:numLabel];
        [letLabels addObject:letLabel];
	}
	
}

- (void) setUpTextandButtons {

    
	UILabel *backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, 300, 90)];
	[backgroundLabel setBackgroundColor:[UIColor blackColor]];
	[backgroundLabel.layer setBorderWidth:2.0f];
	[self.view addSubview:backgroundLabel];
	
	
	textComments = [[UITextView alloc] initWithFrame:CGRectMake(backgroundLabel.frame.origin.x, backgroundLabel.frame.origin.y, 
																180, backgroundLabel.frame.size.height)];
	[textComments setScrollEnabled:YES];
	[textComments setEditable:NO];
	[textComments setBackgroundColor:[UIColor clearColor]];
	[textComments.layer setBorderColor:[[UIColor whiteColor] CGColor]];
	[textComments.layer setBorderWidth:1.0f];
	[textComments setTextColor:[UIColor whiteColor]];
	[textComments setFont:[UIFont fontWithName:@"Courier-Bold" size:12]];
	[textComments setText:@"Moves"];
	[textComments setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	//textComments.layer.cornerRadius = 5;
	[self.view addSubview:textComments];
	
	forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[forwardButton setBackgroundColor:[UIColor clearColor]];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[noteButton setBackgroundColor:[UIColor clearColor]];
	[forwardButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
	[forwardButton.layer setBorderWidth:1.0f];
	[backButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
	[backButton.layer setBorderWidth:1.0f];
	[noteButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
	[noteButton.layer setBorderWidth:1.0f];
	backButton.frame = CGRectMake(textComments.frame.origin.x + textComments.frame.size.width, backgroundLabel.frame.origin.y, 
								  (backgroundLabel.frame.size.width - textComments.frame.size.width)/2, backgroundLabel.frame.size.height/2 );
	forwardButton.frame = CGRectMake(backButton.frame.origin.x + backButton.frame.size.width, backgroundLabel.frame.origin.y, 
									 backButton.frame.size.width, backButton.frame.size.height);
	noteButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y + backButton.frame.size.height, 
								  2*backButton.frame.size.width, backButton.frame.size.height);
	[noteButton setTitle:@"Options" forState:UIControlStateNormal];
    [noteButton addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];

	
	[backButton setImage:[UIImage imageNamed:@"icon_arrow_left.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	[forwardButton setImage:[UIImage imageNamed:@"icon_arrow_right.png"] forState:UIControlStateNormal];
	[forwardButton addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:forwardButton];
	[self.view addSubview:backButton];
	[self.view addSubview:noteButton];
	
}

-(void) setUpPiecesFromState:(BoardState *)state {
	Piece *tmpPiece;
	for (int i = 0; i < [state.piecesArray count]; i ++) {
		tmpPiece = [state.piecesArray objectAtIndex:i];
		[self addPiece:tmpPiece];
	}
}


- (void) setUpPiecesRegular {

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *theData = [prefs dataForKey:@"Saved States"];
	NSArray *statesArray = [NSKeyedUnarchiver unarchiveObjectWithData:theData];
	NSLog(@"states array 0 %@", [statesArray objectAtIndex:0]);
	[self setUpPiecesFromState:[statesArray objectAtIndex:0]];
}


- (void)addPiece:(Piece *)piece {

	if (piece.white == white) {
		[whitePieces addObject:piece]; 
	}
	else {
		[blackPieces addObject:piece];
	}
	
	//[(UIImageView *)[squareDict objectForKey:piece.square] setImage:[piece getPieceImage]];
	[(UIImageView *)[squareDict objectForKey:piece.square] setImage:[piece getPieceImage]];
		
}

-(void) highlightSquare:(NSString *)key withColor:(UIColor *)color {
	[((UIImageView *)[squareDict objectForKey:key]).layer setBorderColor:[color CGColor]];
	[((UIImageView *)[squareDict objectForKey:key]).layer setBorderWidth:2.0];

	
}
-(void) unhighlightSquare:(NSString *)key {
	[((UIImageView *)[squareDict objectForKey:key]).layer setBorderWidth:0.0];
}


-(void) carryOutMove {
	if (moveCount < [movesArray count]) {
		/*Move *nextMove = [[Move alloc] init];*/
		
		Move* nextMove = [movesArray objectAtIndex:moveCount];
		
		/*Piece *nextPiece = [[[Piece alloc] init] autorelease];*/
		Piece *nextPiece;
        if (nextMove.resign || nextMove.draw) {
            //don't do anythnig
            if (nextMove.resign) {
                NSString *tmpMessage;
                if (nextMove.aPiece.white) {
                    tmpMessage = [[NSString alloc] initWithString:@"White resigned!"];
                }
                else {
                    tmpMessage = [[NSString alloc] initWithString:@"Black resigned!"];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" 
                                                                message:tmpMessage 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles: nil];
                alert.tag = 2;
                [alert show];
                [alert release];
                [tmpMessage release];
            }
            else if (nextMove.draw) {
                NSString *tmpMessage;
                tmpMessage = [[NSString alloc] initWithString:@"Draw!"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" 
                                                                message:tmpMessage 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles: nil];
                alert.tag = 2;
                [alert show];
                [alert release];
                [tmpMessage release];
                
            }

            gameIsOver = YES;
            [self movePiece:nil withMove:nextMove];
        }
        else {
            if (nextMove.kCastle || nextMove.qCastle) {
                NSLog(@"castle");
                [self movePiece:nil withMove:nextMove];
            }
            else {
                if (nextMove.take) {
                    NSLog(@"%d. %@x%@", nextMove.moveNumber,nextMove.aPiece.name, nextMove.endSquare);
                }
                else {
                    NSLog(@"%d. %@%@", nextMove.moveNumber,nextMove.aPiece.name, nextMove.endSquare);
                }
                nextPiece = [self getPiece:nextMove andColor:nextMove.aPiece.white];
                [self movePiece:nextPiece withMove:nextMove];
            }
        }
        [self playSound];
		[self addMoveToComments:nextMove];
		[movesMade addObject:nextMove];
        if (nextMove.checkmate) {
            gameIsOver = YES;
            //checkmate! alert
            NSString *tmpMessage;
            if (nextMove.aPiece.white) {
                tmpMessage = [[NSString alloc] initWithString:@"White won!"];
            }
            else {
                tmpMessage = [[NSString alloc] initWithString:@"Black won!"];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" 
                                                            message:tmpMessage 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
            [alert release];
            [tmpMessage release];
        }

	}
    
	
}


-(BOOL) isInCheck:(BOOL)color withMove:(Move *)move {
	NSArray *tmpArray;
	NSString *kingSquare;
	Piece *editPiece;
	//this ensures that we move the actual piece in our arrays
	if (move.aPiece.white) {
		tmpArray = whitePieces;
	}
	else {
		tmpArray = blackPieces;
	}
	for (int i = 0; i < [tmpArray count]; i ++) {
		if ([((Piece *)[tmpArray objectAtIndex:i]).square isEqualToString:move.aPiece.square] ) {
			editPiece = [tmpArray objectAtIndex:i];
			break;
		}
	}

	if (color == white) {
		tmpArray = blackPieces;
		for (int i = 0; i < [whitePieces count]; i++) {
			Piece *tmpPiece = [whitePieces objectAtIndex:i];
			if ([tmpPiece.name isEqualToString:@"K"]) {
				kingSquare = [[NSString alloc] initWithString:tmpPiece.square];
				break;
			}
		}
	}
	else {
		tmpArray = whitePieces;
		for (int i = 0; i < [blackPieces count]; i++) {
			Piece *tmpPiece = [blackPieces objectAtIndex:i];
			if ([tmpPiece.name isEqualToString:@"K"]) {
				kingSquare = [[NSString alloc] initWithString:tmpPiece.square];
				break;
			}
		}
		
	}

	//first check last move, if there is a move
	Move *tmpMove = [[Move alloc] init];
	[tmpMove initialize];
	[tmpMove.endSquare setString:kingSquare];
	if (move) {
		if (move.aPiece.white != color) {
			//opposition is making a move to check
			[tmpMove.aPiece.name setString:move.aPiece.name];
			[tmpMove.aPiece.square setString:move.endSquare];
			[tmpMove.startSquare setString:move.endSquare];
			tmpMove.take = move.take;
			if ([self piece:move.aPiece canMakeMove:tmpMove checkForCheck:NO]) {
				[tmpMove release];
				return YES;
			}
			
		}
		else {
			//making a move to get out of check
			//only way to check is to go through array
			//temporarily make move?
			//then undo move
			
			//[self movePiece:move.aPiece withMove:move];

			[self movePiece:editPiece withMove:move];

			[movesMade addObject:move];
			[movesArray addObject:move];
			if ([move.aPiece.name isEqualToString:@"K"]) {
				//kingsquare changed
				[tmpMove.endSquare setString:move.endSquare];
			}
		}


	}

	for (int i = 0; i < [tmpArray count]; i ++) {
		tmpMove.aPiece = [tmpArray objectAtIndex:i];
		[tmpMove.startSquare setString:((Piece *)[tmpArray objectAtIndex:i]).square];

		tmpMove.take = YES;
		if (![tmpMove.aPiece.square isEqualToString:move.aPiece.square]) {
			if ([self piece:tmpMove.aPiece canMakeMove:tmpMove checkForCheck:NO]) {
				[tmpMove release];
				if (move.aPiece.white == color) {
					//undo temporary move
					[self removeLastMoveAndComment:NO];
					[movesArray removeLastObject];
				}
				return YES;
			}
		}
		
	}

	[tmpMove release];
	if (move.aPiece.white == color) {
		//undo temporary move
		[self removeLastMoveAndComment:NO];
		[movesArray removeLastObject];
	}
	
	return NO;

	
}


-(BOOL)isInCheckmate:(BOOL)color {
	NSMutableArray *possibleMoves = [[NSMutableArray alloc] init];
	NSArray *tmpArray;
	if (color == white) {
		tmpArray = whitePieces;
	}
	else {
		tmpArray = blackPieces;
	}
	
	///iterate through all pieces
	Move *move;
	for (int i = 0; i < [tmpArray count]; i++) {
		Piece *tmpPiece = [tmpArray objectAtIndex:i];
		if ([tmpPiece.name isEqualToString:@"P"]) {
			
			//move up one
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0], 
									   [tmpPiece.square characterAtIndex:1] + [tmpPiece getForwardDirection]]];
			[possibleMoves addObject:move];
			[move release];
			
			//move up two, if allowed
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0], 
									   [tmpPiece.square characterAtIndex:1] + 2*[tmpPiece getForwardDirection]]];
			[possibleMoves addObject:move];
			[move release];
			
			//take left
			if ([self color:!color hasPieceOnSquare:[NSString stringWithFormat:@"%c%c", 
													 [tmpPiece.square characterAtIndex:0] - 1, 
													 [tmpPiece.square characterAtIndex:1] + [tmpPiece getForwardDirection]]]) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				move.take = YES;
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
										   [tmpPiece.square characterAtIndex:0] - 1, 
										   [tmpPiece.square characterAtIndex:1] + [tmpPiece getForwardDirection]]];
				[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];

				[possibleMoves addObject:move];
				[move release];
			}
				 
			if ([self color:!color hasPieceOnSquare:[NSString stringWithFormat:@"%c%c", 
													 [tmpPiece.square characterAtIndex:0] + 1, 
													 [tmpPiece.square characterAtIndex:1] + [tmpPiece getForwardDirection]]]) {
				//take right
				
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				move.take = YES;
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
										   [tmpPiece.square characterAtIndex:0] + 1, 
										   [tmpPiece.square characterAtIndex:1] + [tmpPiece getForwardDirection]]];
				[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];

				[possibleMoves addObject:move];
				[move release];
			}

			
			
			//iterate through to check
			for (int i = 0; i < [possibleMoves count]; i ++) {
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			

			}
			[possibleMoves removeAllObjects];
		}
		else if ([tmpPiece.name isEqualToString:@"R"]) {
			
			//rook right direction
			for (int i = (int)[tmpPiece.square characterAtIndex:0] + 1; i <= 'h'; i++) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];				
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char)i, [tmpPiece.square characterAtIndex:1]]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}

				}

			}
			//periodically check, for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];

			//rook left direction
			for (int i = (int)[tmpPiece.square characterAtIndex:0] - 1; i >= 'a' ; i --) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				//[move.aPiece.name setString:@"R"];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char)i, [tmpPiece.square characterAtIndex:1]]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
			}
			//periodically check, for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//rook up direction
			for (int i = (int)[tmpPiece.square characterAtIndex:1] + 1; i <= 8; i ++) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				//[move.aPiece.name setString:@"R"];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", [tmpPiece.square characterAtIndex:0], (char)i]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
				
			}
			//periodically check, for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//rook down direction
			for (int i = (int)[tmpPiece.square characterAtIndex:1] - 1; i >= 1; i --) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				//[move.aPiece.name setString:@"R"];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", [tmpPiece.square characterAtIndex:0], (char)i]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
			}
			//periodically check, for efficiency
			
			for (int i = 0; i < [possibleMoves count]; i ++) {/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
		}
		else if ([tmpPiece.name isEqualToString:@"N"]) {
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 1, 
									   [tmpPiece.square characterAtIndex:1] + 2]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 1, 
									   [tmpPiece.square characterAtIndex:1] - 2]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 1, 
									   [tmpPiece.square characterAtIndex:1] + 2]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 1, 
									   [tmpPiece.square characterAtIndex:1] - 2]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 2, 
									   [tmpPiece.square characterAtIndex:1] + 1]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 2, 
									   [tmpPiece.square characterAtIndex:1] - 1]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 2, 
									   [tmpPiece.square characterAtIndex:1] + 1]];
			[possibleMoves addObject:move];
			[move release];
			
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 2, 
									   [tmpPiece.square characterAtIndex:1] - 1]];
			[possibleMoves addObject:move];
			[move release];
			
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
					[((Move *)[possibleMoves objectAtIndex:i]).pieceTaken 
					 setString:((Piece *)[self getColor:!color pieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]).name];

				}
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
		}
		else if ([tmpPiece.name isEqualToString:@"B"]) {
			
			//bishop right, up direction
			char r = [tmpPiece.square characterAtIndex:1] + 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] + 1; i < 'h'; i ++) {
				if (r > 8) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];

					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r++;
					}
					else {
						break;
					}
				}
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//bishop right, down direction
			r = [tmpPiece.square characterAtIndex:1] - 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] + 1; i < 'h'; i ++) {
				if (r < 1) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];

					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r--;
					}
					else {
						break;
					}
					
				}
				
				
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//bishop left, up direction
			r = [tmpPiece.square characterAtIndex:1] + 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] - 1; i > 'a'; i ++) {
				if (r > 8) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];

					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r++;
					}
					else {
						break;
					}
					
				}
				
				
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//bishop left, down direction
			r = [tmpPiece.square characterAtIndex:1] - 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] - 1; i > 'a'; i ++) {
				if (r < 1) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r--;
					}
					else {
						break;
					}
				}
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
		}
		else if ([tmpPiece.name isEqualToString:@"Q"]) {
			
			//bishop right, up direction
			char r = [tmpPiece.square characterAtIndex:1] + 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] + 1; i < 'h'; i ++) {
				if (r > 8) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r++;
					}
					else {
						break;
					}
				}
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//bishop right, down direction
			r = [tmpPiece.square characterAtIndex:1] - 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] + 1; i < 'h'; i ++) {
				if (r < 1) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r--;
					}
					else {
						break;
					}
					
				}
				
				
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//bishop left, up direction
			r = [tmpPiece.square characterAtIndex:1] + 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] - 1; i > 'a'; i ++) {
				if (r > 8) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r++;
					}
					else {
						break;
					}
					
				}
				
				
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//bishop left, down direction
			r = [tmpPiece.square characterAtIndex:1] - 1;
			for (int i = (int)[tmpPiece.square characterAtIndex:0] - 1; i > 'a'; i ++) {
				if (r < 1) {
					break;
				}
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char) i, (char) r]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
						r--;
					}
					else {
						break;
					}
				}
			}
			
			//periodically check for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//rook right direction
			for (int i = (int)[tmpPiece.square characterAtIndex:0] + 1; i <= 'h'; i++) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];				
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char)i, [tmpPiece.square characterAtIndex:1]]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
				
			}
			//periodically check, for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//rook left direction
			for (int i = (int)[tmpPiece.square characterAtIndex:0] - 1; i >= 'a' ; i --) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				//[move.aPiece.name setString:@"R"];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", (char)i, [tmpPiece.square characterAtIndex:1]]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
			}
			//periodically check, for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//rook up direction
			for (int i = (int)[tmpPiece.square characterAtIndex:1] + 1; i <= 8; i ++) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				//[move.aPiece.name setString:@"R"];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", [tmpPiece.square characterAtIndex:0], (char)i]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
				
			}
			//periodically check, for efficiency
			for (int i = 0; i < [possibleMoves count]; i ++) {
				//if there is a piece there, then take it.
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
			//rook down direction
			for (int i = (int)[tmpPiece.square characterAtIndex:1] - 1; i >= 1; i --) {
				move = [[Move alloc] init];
				[move initialize];
				[move setAPiece:tmpPiece];
				//[move.aPiece.name setString:@"R"];
				[move.startSquare setString:tmpPiece.square];
				[move.endSquare setString:[NSString stringWithFormat:@"%c%c", [tmpPiece.square characterAtIndex:0], (char)i]];
				if ([self color:!color hasPieceOnSquare:move.endSquare]) {
					move.take = YES;
					[move.pieceTaken setString:((Piece *)[self getColor:!color pieceOnSquare:move.endSquare]).name];
					[possibleMoves addObject:move];
					[move release];
					break;
				}
				else {
					if ([self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare]) {
						[possibleMoves addObject:move];
						[move release];
					}
					else {
						break;
					}
					
				}
			}
			//periodically check, for efficiency			
			for (int i = 0; i < [possibleMoves count]; i ++) {
				/*
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
				}*/
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
		}
		else if ([tmpPiece.name isEqualToString:@"K"]) {
			
			//up
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0], 
									   [tmpPiece.square characterAtIndex:1] + 1]];
			[possibleMoves addObject:move];
			[move release];
			
			//down
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0], 
									   [tmpPiece.square characterAtIndex:1] - 1]];
			[possibleMoves addObject:move];
			[move release];
			
			//right
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 1, 
									   [tmpPiece.square characterAtIndex:1]]];
			[possibleMoves addObject:move];
			[move release];
			
			//left
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 1, 
									   [tmpPiece.square characterAtIndex:1]]];
			[possibleMoves addObject:move];
			[move release];
			
			//up right
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 1, 
									   [tmpPiece.square characterAtIndex:1] + 1]];
			[possibleMoves addObject:move];
			[move release];
			
			//up left
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 1, 
									   [tmpPiece.square characterAtIndex:1] + 1]];
			[possibleMoves addObject:move];
			[move release];
			
			//down left
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] - 1, 
									   [tmpPiece.square characterAtIndex:1] - 1]];
			[possibleMoves addObject:move];
			[move release];
			
			//down right
			move = [[Move alloc] init];
			[move initialize];
			[move setAPiece:tmpPiece];
			[move.startSquare setString:tmpPiece.square];
			[move.endSquare setString:[NSString stringWithFormat:@"%c%c", 
									   [tmpPiece.square characterAtIndex:0] + 1, 
									   [tmpPiece.square characterAtIndex:1] - 1]];
			[possibleMoves addObject:move];
			[move release];

			//iterate through
			for (int i = 0; i < [possibleMoves count]; i ++) {
				if ([self color:!tmpPiece.white hasPieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]) {
					((Move *)[possibleMoves objectAtIndex:i]).take = YES;
					[((Move *)[possibleMoves objectAtIndex:i]).pieceTaken 
					 setString:((Piece *)[self getColor:!color pieceOnSquare:((Move *)[possibleMoves objectAtIndex:i]).endSquare]).name];
				}
				if ([self piece:tmpPiece canMakeMove:(Move *)[possibleMoves objectAtIndex:i] checkForCheck:YES]) {
					return NO;
				}
			}
			[possibleMoves removeAllObjects];
			
		}
	}
	return YES;
	
	
}




-(void) addMoveToComments:(Move *)nextMove {
   
	NSString *commentString = [[NSString alloc] initWithString:[self convertMoveToString:nextMove]];
	
	[textComments setText:[NSString stringWithFormat:@"%@%@", textComments.text, commentString]];
	[commentString release];
	if ([textComments.text length] > 1) {
		[textComments scrollRangeToVisible:NSMakeRange([textComments.text length], 1)];
	}
}

-(NSString *) convertMoveToString:(Move *)nextMove {

	NSMutableString *commentString = [[[NSMutableString alloc] initWithString:@""] autorelease];
	NSMutableString *move = [[NSMutableString alloc] initWithString:@""];
    if (!nextMove) {
        [move appendFormat:@"\n0."];
        while ([move length] < 13) {
            [move appendFormat:@" "];
        }
    }
    else {
        if (nextMove.aPiece.white) {
            [move appendFormat:@"\n%d.", nextMove.moveNumber];
            while ([move length] < 5) {
                [move appendFormat:@" "];
            }
        }
        
        if (nextMove.resign) {
            if (nextMove.aPiece.white) {
                [move appendFormat:@"0 - 1"];
            }
            else {
                [move appendFormat:@"1 - 0"];
            }
        }
        else if (nextMove.draw || nextMove.stalemate) {
            [move appendFormat:@"1/2-1/2"];
        }
        else {
            if (nextMove.kCastle) {
                [move appendFormat:@"O-O"];
            }
            else if (nextMove.qCastle) {
                [move appendFormat:@"O-O-O"];
            }
            else {
                if (nextMove.start) {
                    [move appendFormat:@"%c", nextMove.start];
                }
                if ([nextMove.aPiece.name isEqual:@"P"]) {
                    //don't append
                }
                else {
                    [move appendFormat:@"%@", nextMove.aPiece.name];
                }
                if (nextMove.take) {
                    if ([nextMove.aPiece.name isEqual:@"P"]) {
                        [move appendFormat:@"%c", [nextMove.aPiece.square characterAtIndex:0]];
                    }
                    [move appendFormat:@"x"];
                }
                [move appendFormat:@"%@", nextMove.endSquare];
                if (nextMove.promote) {
                    [move appendFormat:@"=%@", nextMove.promotePiece];
                }
            }
            
            if (nextMove.check) {
                [move appendFormat:@"+"];
            }
            else if (nextMove.checkmate) {
                [move appendFormat:@"++"];
            }
        }
        
        
        if (nextMove.aPiece.white) {
            while ([move length] < 13) {
                [move appendFormat:@" "];
            }
        }
        else {
            while ([move length] < 8) {
                [move appendFormat:@" "];
            }
        }

        
    }
		NSLog(@"move.%@.", move);
	[commentString appendFormat:@" %@", move];
	/*
	if ([nextMove.comments length] > 0) {
		
		if (!nextMove.aPiece.white) {
			[commentString appendFormat:@" - %@", nextMove.comments];
		}
		
	}
	 */
	[move release];
	return commentString;
}


-(Piece *)getPiece:(Move *)givenMove andColor:(BOOL)color {
	NSArray *tmpPieces;
	Piece *tmpPiece;
	if (color == white) {
		tmpPieces = whitePieces;
	}
	else {
		tmpPieces = blackPieces;
	}
	if ([givenMove.startSquare length] > 0) {
		for (int i = 0; i < [tmpPieces count]; i++) {
			tmpPiece = [tmpPieces objectAtIndex:i];
			if ([tmpPiece.square isEqualToString:givenMove.startSquare]) {
				break;
			}
		}
	}
	else {
		for (int i = 0; i < [tmpPieces count]; i++) {
			tmpPiece = [tmpPieces objectAtIndex:i];
			if ([givenMove.aPiece.name isEqual:tmpPiece.name]) {
				//may be the same piece
				//check if piece can move to that square.
				if (givenMove.start) {
					char start = givenMove.start;
					
					if (start == [tmpPiece.square characterAtIndex:1] || start == [tmpPiece.square characterAtIndex:0] ) {
						if ([self piece:tmpPiece canMakeMove:givenMove checkForCheck:NO]) {
							break;
						}
					}
				}
				else {
					if ([self piece:tmpPiece canMakeMove:givenMove checkForCheck:NO]) {
						break;
					}
				}
			}
		}
	}
	return tmpPiece;

	
	

}

-(BOOL) piece:(Piece *)potPiece canMakeMove:(Move *)move checkForCheck:(BOOL)check {
	char pC = [move.startSquare characterAtIndex:0];
	char pR = [move.startSquare characterAtIndex:1];
	char eC = [move.endSquare characterAtIndex:0];
	char eR = [move.endSquare characterAtIndex:1];
	BOOL rVal = NO;
	
	if (pC > 'h' || pC < 'a' || eC > 'h' || eC < 'a' || 
		pR < '1' || pR > '8' || eR < '1' || eR > '8') {
		return NO;
	}
	if ([self color:potPiece.white hasPieceOnSquare:move.endSquare]) {
		return NO;
	}

	/*
	if (check) {
		//check for check only on an actualy move, not just checking if a piece can get to one square to another
		if ([self isInCheck:potPiece.white withMove:move]) {
			return NO;
		}
	}
	*/

	if ([potPiece.name isEqual:@"P"]) {
		//is pawn. 
		int forward = [potPiece getForwardDirection];
		
		if (move.take) {
			//pawn moves diagonal
			//check to see if the pawn only advanced one
			if ((int)pR + forward == (int)eR) {
				if ((eC - pC) == 1 || (eC - pC) == -1) {
					rVal = YES;
					//return YES;
				}
			}
			if (!rVal) {
				return NO;
			}
			//return NO;
		}
		else {
			if (((UIImageView *)[squareDict objectForKey:move.endSquare]).image) {
				return NO;
			}
			if (eC == pC) {
				if ((int)pR + forward == (int)eR) {
					rVal = YES;
					//return YES;
				}
				else {
					//check if first move, can advance 2
					if (potPiece.white) {
						if (pR == '2') {
							
							if ((int)pR + 2*forward == (int)eR) {
								rVal = YES;
								//return YES;
							}
						}
					}
					else {
						if (pR == '7') {
							
							if ((int)pR + 2*forward == (int)eR) {
								rVal = YES;
								//return YES;
							}
						}
					}
				}
			}
			if (!rVal) {
				return NO;
			}
			//return NO;
		}

	}
	else if ([potPiece.name isEqual:@"R"]) {
		if (pC == eC) {
			//same column
			//check to make sure there arent pieces in between the path
			rVal = [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
			//return [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
		}
		else if (pR == eR) {
			//same row
			rVal = [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
			//return [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
		}
		/*
		else {
			return NO;
		}
		 */
		if (!rVal) {
			return NO;
		}

	}
	else if ([potPiece.name isEqual:@"B"]) {
		
		//check if same color bishop
		if (abs(eC - pC) == abs(eR - pR)) {
			rVal = [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
			//return [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
		}
		if (!rVal) {
			return NO;
		}
		/*
		else {
			return NO;
		}
		 */

	}
	else if ([potPiece.name isEqual:@"N"]){
		NSLog(@"knight %@", move.startSquare);
		if ((pC - eC == 2) || (pC - eC == -2)) {
			//horizontal move
			//check to make sure vertical is only 1
			rVal = ((pR - eR == 1) || (pR - eR == -1));
			//return ((pR - eR == 1) || (pR - eR == -1));
		}
		else if ((pR - eR == 2) || (pR - eR == -2)) {
			//vertical move
			//check to make sure horizontal is only 1
			rVal = ((pC - eC == 1) || (pC - eC == -1));
			//return ((pC - eC == 1) || (pC - eC == -1));
		}
		if (!rVal) {
			return NO;
		}
		/*
		else {
			return NO;
		}
		*/

	}

	else if ([potPiece.name isEqual:@"Q"]){
		//must be queen
		//unless promote. will take care of later
		//move horizontal
		if (abs(eC - pC) == abs(eR - pR)) {
			rVal = [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
			//return [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
		}
		else {
			if (abs(eC - pC) == 0 || abs(eR - pR) == 0) {
				rVal = [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
				//return [self pathIsEmptyFromStart:move.startSquare toEnd:move.endSquare];
			}
		}
		if (!rVal) {
			return NO;
		}
		
		//return NO;
	}
	else if ([potPiece.name isEqual:@"K"]){
		//must be king
		if (move.kCastle || move.qCastle) {
			//check to make sure king hasn't moved yet
			if (potPiece.hasMoved) {
				return NO;
			}
			else {
				NSArray *tmpColorPieces;
				if (potPiece.white) {
					tmpColorPieces = whitePieces;
				}
				else {
					tmpColorPieces = blackPieces;
				}

				if (move.kCastle) {
					for (int i = 0; i < [tmpColorPieces count]; i++) {
						Piece *piece = [tmpColorPieces objectAtIndex:i];
						if ([piece.name isEqual:@"R"] && [piece.square characterAtIndex:1] == [potPiece.square characterAtIndex:1] 
							&& [piece.square characterAtIndex:0] == 'h' && !piece.hasMoved) {
							if ([self pathIsEmptyFromStart:move.startSquare toEnd:piece.square]) {
								rVal = YES;
								//return YES;
								break;
							}
						}
					}
				}
				else {
					for (int i = 0; i < [tmpColorPieces count]; i++) {
						Piece *piece = [tmpColorPieces objectAtIndex:i];
						if ([piece.name isEqual:@"R"] && [piece.square characterAtIndex:1] == [potPiece.square characterAtIndex:1] 
							&& [move.startSquare characterAtIndex:0] == 'a' && !piece.hasMoved) {
							if ([self pathIsEmptyFromStart:move.startSquare toEnd:piece.square]) {
								rVal = YES;
								//return YES;
								break;
							}
						}
					}
				}

			}

		}
		
		else {
			if (fabs(pC - eC) == 1 && fabs(pR - eR) == 1 ) {
				rVal = YES;
				//return YES;
			}
			else if (fabs(pC - eC) == 1 && fabs(pR - eR) == 0) {
				rVal = YES;
				//return YES;
			}
			else if (fabs(pC - eC) == 0 && fabs(pR - eR) == 1) {
				rVal = YES;
				//return YES;
			}
		}
		if (!rVal ) {
			return NO;
		}
		//return NO;

	}
	else {
		NSLog(@"error - piece.name %@", potPiece.name);
		return NO;
	}

	
	if (check && rVal) {
		//check for check only on an actualy move, not just checking if a piece can get to one square to another
		NSArray *tmpArray;
		if (move.aPiece.white) {
			tmpArray = whitePieces;
		}
		else {
			tmpArray = blackPieces;
		}
		Piece *tmpPiece;
		for (int i = 0; i < [tmpArray count] ; i ++) {
			tmpPiece = [tmpArray objectAtIndex:i];
			if ([tmpPiece.square isEqual:move.aPiece.square]) {
				break;
			}
		}
		move.aPiece = tmpPiece;
		if ([self isInCheck:potPiece.white withMove:move]) {
			
			return NO;
		}
		else {
			return YES;
		}

	}

	if (rVal) {
		return YES;
	}
	return NO;

		
}

-(BOOL) pathIsEmptyFromStart:(NSString *)startSquare toEnd:(NSString *)endSquare {
	char sC = [startSquare characterAtIndex:0];
	char sR = [startSquare characterAtIndex:1];
	char eC = [endSquare characterAtIndex:0];
	char eR = [endSquare characterAtIndex:1];
	int sS, eS;
	if (sC == eC) {
		//moving along collumn
		if (sR > eR) {
			sS = eR - '0';
			eS = sR - '0';
		}
		else {
			sS = sR - '0';
			eS = eR - '0';
		}
		for (int i = sS + 1; i < eS ; i ++) {
			if ([self squareIsEmpty:[NSString stringWithFormat:@"%c%d", sC, i]]) {
				//square is empty, okay to continue
			}
			else {
				return NO;
			}
		}
	}
	else if (sR == eR) {
		//moving along a row
		if (sC > eC) {
			sS = (eC - 'a');
			eS = (sC - 'a');
		}
		else {
			sS = (sC - 'a');
			eS = (eC - 'a');
		}
		for (int i = sS + 1; i < eS ; i ++) {
			if ([self squareIsEmpty:[NSString stringWithFormat:@"%c%c", (char)(i + 'a'), sR]]) {
				//square is empty, okay to continue
			}
			else {
				return NO;
			}
		}
	}
	else if (abs(eR - sR) == abs(eC - sC)) {
		//moving along diagonal
		int rP, cP;
		if (sC < eC) {
			cP = 1;
			sS = (sC - 'a');
			eS = (eC - 'a');
		}
		else {
			cP = -1;
			sS = (eC - 'a');
			eS = (sC - 'a');
		}
		if (sR < eR) {
			rP = 1;
		}
		else {
			rP = -1;
		}
		for (int i = 1; i < (eS - sS); i ++) {
			if ([self squareIsEmpty:[NSString stringWithFormat:@"%c%c", (char)(sC + cP*i), (sR + rP *i)]]) {
				//square is empty, okay to continure
			}
			else {
				return NO;
			}

		}


	}
	
	
	
	
	
	
	
	
	
	return YES;
}

-(void) removeLastMoveAndComment:(BOOL)rmComment {

    if ([movesMade count] == 0) {
        return;
    }
	Move *lastMove = [movesMade lastObject];
    
	[movesMade removeLastObject];
	Piece *lastPiece;
	NSMutableArray *tmpArray;
	if (lastMove.resign || lastMove.draw) {
        //don't do anything
    }
	else {
        if (lastMove.aPiece.white) {
            tmpArray = whitePieces;
        }
        else {
            tmpArray = blackPieces;
        }
        
        for (int i = 0; i < [tmpArray count]; i++) {
            lastPiece = [tmpArray objectAtIndex:i];
            if ([lastPiece.square isEqualToString:lastMove.endSquare]) {
                break;
            }
        }
        if (lastMove.kCastle) {
            //king castle, do something
            Piece *rookPiece;
            int row;
            if (lastPiece.white) {
                row = 1;
            }
            else {
                row = 8;
            }
            for (int i = 0; i < [tmpArray count]; i++) {
                rookPiece = [tmpArray objectAtIndex:i];
                if ([rookPiece.square isEqualToString:[NSString stringWithFormat:@"f%d", row]]) {
                    break;
                }
            }
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"e%d", row]]).image = [lastPiece getPieceImage];
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"h%d", row]]).image = [rookPiece getPieceImage];
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"f%d", row]]).image = nil;
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"g%d", row]]).image = nil;
            [rookPiece.square setString:[NSString stringWithFormat:@"h%d", row]];
            [lastPiece.square setString:[NSString stringWithFormat:@"e%d", row]];
            
            
        }
        else if (lastMove.qCastle) {
            //queen castle, do something
            Piece *rookPiece;
            int row;
            if (lastPiece.white) {
                row = 1;
            }
            else {
                row = 8;
            }
            for (int i = 0; i < [tmpArray count]; i++) {
                rookPiece = [tmpArray objectAtIndex:i];
                if ([rookPiece.square isEqualToString:[NSString stringWithFormat:@"d%d", row]]) {
                    break;
                }
            }
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"e%d", row]]).image = [lastPiece getPieceImage];
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"a%d", row]]).image = [rookPiece getPieceImage];
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"d%d", row]]).image = nil;
            ((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"c%d", row]]).image = nil;
            [rookPiece.square setString:[NSString stringWithFormat:@"a%d", row]];
            [lastPiece.square setString:[NSString stringWithFormat:@"e%d", row]];
        }
        else if (lastMove.enPassant) {
            Piece *pieceTaken;
            NSMutableArray *takenArray, *piecesArray;
            
            NSMutableString *takenSquare = [[NSMutableString alloc] init];
            [takenSquare appendFormat:@"%c%c", [lastMove.endSquare characterAtIndex:0], 
             [lastMove.endSquare characterAtIndex:1] - [lastMove.aPiece getForwardDirection]];
            NSLog(@"taken square %@", takenSquare);
            
            
            if (lastMove.aPiece.white) {
                takenArray = blackTaken;
                piecesArray = blackPieces;
            }
            else {
                takenArray = whiteTaken;
                piecesArray = whitePieces;
            }
            
            for (int i = 0; i < [takenArray count]; i ++) {
                pieceTaken = [takenArray objectAtIndex:i];
                if ([pieceTaken.name isEqualToString:@"P"] && [pieceTaken.square isEqualToString:takenSquare]) {
                    [takenArray removeObjectAtIndex:i];
                    [piecesArray addObject:pieceTaken];
                    break;
                }
            }
            ((UIImageView *)[squareDict objectForKey:lastMove.endSquare]).image = nil;
            
            [((UIImageView *)[squareDict objectForKey:lastMove.startSquare]) setImage:[lastMove.aPiece getPieceImage]];
            ((UIImageView *)[squareDict objectForKey:pieceTaken.square]).image = [pieceTaken getPieceImage];
            
            [lastPiece.square setString:lastMove.startSquare];
            
            
            
        }
        else {
            if (lastMove.take) {
                //took a piece
                Piece *pieceTaken;
                NSMutableArray *takenArray, *piecesArray;
                
                if (lastMove.aPiece.white) {
                    takenArray = blackTaken;
                    piecesArray = blackPieces;
                }
                else {
                    takenArray = whiteTaken;
                    piecesArray = whitePieces;
                }
                
                for (int i = 0; i < [takenArray count]; i ++) {
                    pieceTaken = [takenArray objectAtIndex:i];
                    if ([pieceTaken.name isEqualToString:lastMove.pieceTaken] && [pieceTaken.square isEqualToString:lastMove.endSquare]) {
                        [takenArray removeObjectAtIndex:i];
                        [piecesArray addObject:pieceTaken];
                        
                        break;
                    }
                }
                
                UIImage *tmpImage;
                tmpImage = ((UIImageView *)[squareDict objectForKey:lastMove.endSquare]).image;
                [((UIImageView *)[squareDict objectForKey:lastMove.startSquare]) setImage:tmpImage];
                ((UIImageView *)[squareDict objectForKey:lastMove.endSquare]).image = [pieceTaken getPieceImage];
                
                [lastPiece.square setString:lastMove.startSquare];
                
                
            }
            else {
                
                //regular move
                UIImage *tmpImage;
                tmpImage = ((UIImageView *)[squareDict objectForKey:lastMove.endSquare]).image;
                [((UIImageView *)[squareDict objectForKey:lastMove.startSquare]) setImage:tmpImage];
                ((UIImageView *)[squareDict objectForKey:lastMove.endSquare]).image = nil;
                
                [lastPiece.square setString:lastMove.startSquare];
                
            }
            if (lastMove.promote) {
                //do something. change piece back to pawn
                [lastPiece.name setString:@"P"];
                [((UIImageView *)[squareDict objectForKey:lastMove.startSquare]) setImage:[lastPiece getPieceImage]];
            }
            
        }
        
        
        
        
        //unhighlight squares
        [self unhighlightSquare:lastMove.startSquare];
        [self unhighlightSquare:lastMove.endSquare];
        if ([movesMade count] > 0) {
            [self highlightSquare:((Move *)[movesMade lastObject]).endSquare withColor:[UIColor yellowColor]];
            [self highlightSquare:((Move *)[movesMade lastObject]).startSquare withColor:[UIColor yellowColor]];
        }
    }
	moveCount --;
	
	if (rmComment) {
		//get rid of comment
		NSMutableString *commentString = [[NSMutableString alloc] initWithString:textComments.text];
		if (moveCount % 2 == 0) {
			[commentString deleteCharactersInRange:NSMakeRange([commentString length] - 14, 14)];
		}
		else {
			[commentString deleteCharactersInRange:NSMakeRange([commentString length] - 9, 9)];
		}
		[textComments setText:commentString];
		[commentString release];
	}



}

-(void) playSound {
    if (soundIsOn) {
        ////add code to play sound
        SystemSoundID soundID;
        NSString *path = [[NSString alloc] initWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/MOVE.WAV"];
        NSLog(@"path %@", path);
        NSURL *filepath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((CFURLRef)filepath, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
 
    

    
}


-(IBAction) backAction:(id)sender {
    
	[self removeLastMoveAndComment:YES];
    [self playSound];
    if (moveCount == 0) {
        [backButton setEnabled:NO];
    }
    if ([movesArray count] > moveCount) {
        //movecount starts at 0
        [forwardButton setEnabled:YES];
    }
	/*
	int count = moveCount;
	[textComments setText:@"Notes"];
	[self resetBoard];
	int i = 0;
	while (i < count - 1) {
		[self carryOutMove:nil];
		i++;
	}
	 */
	
	
}

-(IBAction) forwardAction:(id)sender {
	[self carryOutMove];
    if (moveCount) {
        [backButton setEnabled:YES];
    }
    if ([movesArray count] <= moveCount) {
        [forwardButton setEnabled:NO];
    }
}

-(BOOL) color:(BOOL)color hasPieceOnSquare:(NSString *)square {
	NSArray *tmpArray;
	if (color == white) {
		tmpArray = whitePieces;
	}
	else {
		tmpArray = blackPieces;
	}
	for (int i = 0; i < [tmpArray count]; i ++) {
		if ([((Piece *)[tmpArray objectAtIndex:i]).square isEqualToString:square]) {
			return YES;
		}
	}
	return NO;

}

-(Piece *)getColor:(BOOL)color pieceOnSquare:(NSString *)square {
	NSArray *tmpArray;
	if (color == white) {
		tmpArray = whitePieces;
	}
	else {
		tmpArray = blackPieces;
	}
	for (int i = 0; i < [tmpArray count]; i ++) {
		if ([((Piece *)[tmpArray objectAtIndex:i]).square isEqualToString:square]) {
			return [tmpArray objectAtIndex:i];
		}
	}
	return nil;

}



-(BOOL) squareIsEmpty:(NSString *)square {
	if (((UIImageView *)[squareDict objectForKey:square]).image) {
		return NO;
	}
	else {
		return YES;
	}

}

-(void) resetBoard{
	for (NSString *key in [squareDict allKeys]) {
		[(UIImageView *)[squareDict objectForKey:key] setImage:nil];
	}
	moveCount = 0;
	[whitePieces removeAllObjects];
	[blackPieces removeAllObjects];
	[whiteTaken removeAllObjects];
	[blackTaken removeAllObjects];
	[self setUpPiecesRegular];
	
	
}

- (void) gameIsOver:(char)result {
    //this will be overridden
}


-(void) movePiece:(Piece *)aPiece withMove:(Move *)aMove {
	//need to change pieces on board and in arrays (whitePieces, blackPieces)
    if (aMove.resign || aMove.draw) {
        ///special, don't do anything
                moveCount ++;
        return;
    }
    
	Piece *editPiece;
	NSArray *searchArray;
	if (aPiece.white) {
		searchArray = whitePieces;
	}
	else {
		searchArray = blackPieces;
	}
	for (int i = 0; i < [searchArray count] ; i++) {
		editPiece = [searchArray objectAtIndex:i];
		if ([editPiece.square isEqual:aPiece.square]) {
			break;
		}
	}
	//make any permanent changes on editPiece (actually in piecesArrays)

	if (aMove.kCastle || aMove.qCastle) {
		//castling
		Piece *tmpKing, *tmpRook;
		NSMutableArray *tmpArray;
		if (aMove.aPiece.white) {
			tmpArray = whitePieces;
		}
		else {
			tmpArray = blackPieces;
		}
		//find king piece
		for (int i = 0; i < [tmpArray count]; i++) {
			tmpKing = [tmpArray objectAtIndex:i];
			if ([tmpKing.name isEqual:@"K"]) {
				break;
			}
			
		}
		//find rook piece
		for (int i = 0; i < [tmpArray count]; i++) {
			tmpRook = [tmpArray objectAtIndex:i];
			if ([tmpRook.name isEqual:@"R"]) {
				if (aMove.kCastle) {
					if ([tmpRook.square characterAtIndex:0] == 'h' ) {
						break;
					}
				}
				else {
					if ([tmpRook.square characterAtIndex:0] == 'a') {
						break;
					}
				}
			}
		}
		UIImage *tmpKingImage = ((UIImageView *)[squareDict objectForKey:tmpKing.square]).image;
		UIImage *tmpRookImage = ((UIImageView *)[squareDict objectForKey:tmpRook.square]).image;
		if (aMove.kCastle) {
			char row = [tmpKing.square characterAtIndex:1];
			((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"g%c", row]]).image = tmpKingImage;
			((UIImageView *)[squareDict objectForKey:tmpKing.square]).image = nil;
			((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"f%c", row]]).image = tmpRookImage;
			((UIImageView *)[squareDict objectForKey:tmpRook.square]).image = nil;
			[tmpKing.square setString:[NSString stringWithFormat:@"g%c", row]];
			tmpKing.hasMoved = YES;
			[tmpRook.square setString:[NSString stringWithFormat:@"f%c", row]];
			tmpRook.hasMoved = YES;
		}
		else {
			char row = [tmpKing.square characterAtIndex:1];
			((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"c%c", row]]).image = tmpKingImage;
			((UIImageView *)[squareDict objectForKey:tmpKing.square]).image = nil;
			((UIImageView *)[squareDict objectForKey:[NSString stringWithFormat:@"d%c", row]]).image = tmpRookImage;
			((UIImageView *)[squareDict objectForKey:tmpRook.square]).image = nil;
			[tmpKing.square setString:[NSString stringWithFormat:@"c%c", row]];
			tmpKing.hasMoved = YES;
			[tmpRook.square setString:[NSString stringWithFormat:@"d%c", row]];
			tmpRook.hasMoved = YES;
		}

	}
	else {
		UIImage *tmpImage = ((UIImageView *)[squareDict objectForKey:aPiece.square]).image;
		if (aMove.take) {
			//a piece is taken.
			NSMutableArray *tmpArray;
			NSMutableArray *tmpTaken;
			int enPassantRow;
			if (aPiece.white) {
				tmpArray = blackPieces;
				tmpTaken = blackTaken;
				enPassantRow = 5;
			}
			else {
				tmpArray = whitePieces;
				tmpTaken = whiteTaken;
				enPassantRow = 4;
			}

			if ([aMove.aPiece.name isEqual:@"P"] && [aMove.aPiece.square characterAtIndex:1] - '0' == enPassantRow ) {
				//might be enpasant
				aMove.enPassant = YES;
				for (int i = 0; i < [tmpArray count]; i++) {
					if ([aMove.endSquare isEqual:((Piece *)[tmpArray objectAtIndex:i]).square]) {
						[tmpTaken addObject:[tmpArray objectAtIndex:i]];
						[tmpArray removeObjectAtIndex:i];
						aMove.enPassant = NO;
						break;
						
					}
				}
				if (aMove.enPassant) {
					for (int i = 0; i < [tmpArray count]; i++) {
						NSString *tmpSquare = [[NSString alloc] initWithString:((Piece *)[tmpArray objectAtIndex:i]).square];
						if ([aMove.endSquare characterAtIndex:0] == [tmpSquare characterAtIndex:0] && [aMove.endSquare characterAtIndex:1] == [tmpSquare characterAtIndex:1] + [aMove.aPiece getForwardDirection]) {
							[tmpTaken addObject:[tmpArray objectAtIndex:i]];
							[tmpArray removeObjectAtIndex:i];
							[tmpSquare release];
							break;
							
						}
						else {
							[tmpSquare release];

						}
					}
				}
			}
			else {

				for (int i = 0; i < [tmpArray count]; i++) {
					if ([aMove.endSquare isEqual:((Piece *)[tmpArray objectAtIndex:i]).square]) {
						[tmpTaken addObject:[tmpArray objectAtIndex:i]];
						[tmpArray removeObjectAtIndex:i];
						break;
						
					}
				}

			}

			
		}
		
		if (aMove.promote) {
			NSMutableArray *tmpArray;
			if (aMove.aPiece.white) {
				tmpArray = whitePieces;
			}
			else {
				tmpArray = blackPieces;
			}
			for (int i = 0; i < [tmpArray count]; i ++) {
				if ([((Piece *)[tmpArray objectAtIndex:i]).square isEqual:aMove.startSquare]) {
					[((Piece *)[tmpArray objectAtIndex:i]).name setString:aMove.promotePiece];
					[editPiece.name setString:aMove.promotePiece];
					break;
				}
			}
			NSMutableString *newImageName = [[NSMutableString alloc] init];
			if (aPiece.white) {
				[newImageName appendFormat:@"%@", @"w_"];
			}
			else {
				[newImageName appendFormat:@"%@", @"b_"];
			}
			[newImageName appendFormat:@"%@.png", [piecesDict objectForKey:aPiece.name]];
			

			((UIImageView *)[squareDict objectForKey:aMove.endSquare]).image = [UIImage imageNamed:newImageName];
			[newImageName release];
			((UIImageView *)[squareDict objectForKey:editPiece.square]).image = nil;
			NSLog(@"aPiece.name %@", aPiece.name);
			[editPiece.square setString:aMove.endSquare];
			aPiece.hasMoved = YES;
			

		}

		else if (aMove.enPassant) {
			NSString *tmpSquare = [[NSString alloc] initWithFormat:@"%c%c", [aMove.endSquare characterAtIndex:0], [aMove.endSquare characterAtIndex:1] - [aMove.aPiece getForwardDirection]]; 
			((UIImageView *)[squareDict objectForKey:aMove.endSquare]).image = tmpImage;
			((UIImageView *)[squareDict objectForKey:aPiece.square]).image = nil;
			((UIImageView *)[squareDict objectForKey:tmpSquare]).image = nil;
			NSLog(@"aPiece.name %@", aPiece.name);
			[editPiece.square setString:aMove.endSquare];
			editPiece.hasMoved = YES;
		}
		else {
			((UIImageView *)[squareDict objectForKey:aMove.endSquare]).image = tmpImage;
			((UIImageView *)[squareDict objectForKey:aPiece.square]).image = nil;
			
			[editPiece.square setString:aMove.endSquare];
			editPiece.hasMoved = YES;
		}


	}
	editPiece = nil;
	
	if ([movesMade count] > 0) {
		[self unhighlightSquare:((Move *)[movesMade lastObject]).endSquare];
		[self unhighlightSquare:((Move *)[movesMade lastObject]).startSquare];
	}
	[self highlightSquare:aMove.startSquare withColor:[UIColor yellowColor]];
	[self highlightSquare:aMove.endSquare withColor:[UIColor yellowColor]];
	moveCount ++;
	
}


- (void)flipTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	isBoardFlipped = !isBoardFlipped;
}

-(IBAction) getInfo:(id)sender {
	//infoTable = [[InfoTableController alloc] init];
	/*
	[self.infoTable.view setHidden:NO];
	[self.view bringSubviewToFront:infoTable.view];
	*/
	

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(flipTransitionDidStop:finished:context:)];
	
	if (isBoardFlipped) {
		//flip back to board
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        //[self.view setHidden:YES];
        //[self.infoTable.view setHidden:NO];
		if (self.infoTable.activeField) {
			[self.infoTable.activeField resignFirstResponder];
		}
        else if (self.infoTable.activeView) {
            [self.infoTable.activeView resignFirstResponder];
            
        }
		[self.view sendSubviewToBack:self.infoTable.view];
		[self.infoTable.view setHidden:YES];

		
	}
	else {
		//flip to info table
        [infoTable setResult];
        [infoTable.myTableView reloadData];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [self.view bringSubviewToFront:self.infoTable.view];
		[self.infoTable.view setHidden:NO];
        
	}
	[UIView commitAnimations];
	/*
	NSString *viewControllerName;
	
	InfoViewController *targetViewController;
	viewControllerName = @"InfoViewController";
	
	targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	[targetViewController setTitle:@"Game Info"];
	targetViewController.gameInfo = [gameNotation getInfoArray];

	[self.navigationController pushViewController:targetViewController animated:YES];

	[targetViewController release];
	*/
	
}
- (void) saveBoardStateAction {
    
	[self askForStateTitle];
    
    
}

-(IBAction)optionsAction:(id)sender {
    //this will be overridden
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Flip Board", nil];
    [actionSheet setTag:1];
	[actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        switch (buttonIndex) {
            case 0:
            {
                [self flipBoard];
                break;
            }
            case 1:
            {
                //draw
                if (gameIsOver) {
                    //game is already over
                    break;
                }
                [self draw];
                break;
            }
            case 2:
            {
                //resign
                if (gameIsOver) {
                    //game is already over
                    break;
                }
                [self resign:YES];
                
                break;
            }
            case 3:
            {
                //black resigns
                if (gameIsOver) {
                    //game is already over
                    break;
                }
                [self resign:NO];
                break;
            }
            default:
                
                break;
        }

    }
    else {
        if (buttonIndex == 0) {
            [self flipBoard];
        }
    }
}

-(void) resign:(BOOL)whiteResigns {
    
}

-(void) draw {
    
}



-(void) askForStateTitle {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save State" 
													message:@"this will be covered" 
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:@"Save", nil];
	alert.tag = 5;
	[stateTitleTextField setText:@""];
    [stateTitleTextField becomeFirstResponder];
	[alert addSubview:stateTitleTextField];
    
	[alert show];
	[alert release];
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 5) {
		if (buttonIndex == 1) {
			NSLog(@"text filed text %@", stateTitleTextField.text);
			[self saveBoardState];
		}
	}
}


-(void) saveBoardState {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *savedStatesArray;
	BoardState *newState = [[BoardState alloc] init];
	[newState.piecesArray addObjectsFromArray:whitePieces];
	[newState.piecesArray addObjectsFromArray:blackPieces];
	newState.whiteToMove = (moveCount%2 == 0);
    if (infoTable.activeView) {
        [newState.comments setString:self.infoTable.activeView.text];
    }
    else {  
        NSLog(@"comments %@", self.infoTable.comments);
        [newState.comments setString:self.infoTable.comments];
    }
	newState.stateID = [[NSString alloc] initWithString:[newState getRandomNumber]];
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSLog(@"date %@", [dateFormatter stringFromDate:now]);
	[newState.stateInfo setObject:[dateFormatter stringFromDate:now] forKey:@"Date"];
	[newState.stateInfo setObject:stateTitleTextField.text forKey:@"Title"];
    //[newState.stateInfo setObject:newState.whiteToMove?@"Yes":@"No" forKey:@"Next Move"];
	[dateFormatter release];
    if (infoTable.game) {
        for (int i = 0; i < [infoTable.game.gameInfo count]; i++) {
            //add extra info
        }
    }
	
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
