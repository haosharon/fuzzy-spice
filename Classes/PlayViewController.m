//
//  PlayViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/17/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "PlayViewController.h"
#import "Move.h"

@implementation PlayViewController

@synthesize whiteToMove;
@synthesize promView;



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
    [backButton setEnabled:NO];
    [forwardButton setEnabled:NO];
	activeIV = [UIImageView alloc];
	[activeIV setHidden:YES];
	[self.view addSubview:activeIV];
	imageIV = [[UIImageView alloc] init];
	[self.view addSubview:imageIV];
	[activeIV setUserInteractionEnabled:YES];
	activePiece = [[Piece alloc] init];
	activeMove = [[Move alloc] init];
	[activeMove initialize];
	whiteToMove = YES;
	moveNumber = 0;
	


	[self buildPromotionView];
	gameIsOver = NO;
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
	activeIV = nil;
	activePiece = nil;
	activeMove = nil;
	imageIV = nil;
	promView = nil;
	
    [super dealloc];
}
/*
- (void) buildPromoteView {
	
	promoteView = [[UIView alloc] initWithFrame:self.view.frame];
	[promoteView setBackgroundColor:[UIColor clearColor]];
	NSArray *potPromote = [[NSArray alloc] initWithObjects:@"N", @"B", @"Q", @"R", nil];
	for (int i = 0; i < 4; i ++) {
		UIButton *chooseButton 
	}
	
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSArray *tmpArray;
	if (gameIsOver) {
		return;
	}
	if (whiteToMove) {
		tmpArray = [[NSArray alloc] initWithArray:whitePieces];
	}
	else {
		tmpArray = [[NSArray alloc] initWithArray:blackPieces];
	}
	
	//if drags a piece from side
	Piece *tmpPiece = [[Piece alloc] init];
	for (int i = 0; i < [tmpArray count]; i++) {
		//UIImageView *tmpIV = [[UIImageView alloc] init];
		
		tmpPiece = [tmpArray objectAtIndex:i];
		UIImageView *tmpIV = [squareDict objectForKey:tmpPiece.square];
	
		if ([touch view] == tmpIV) {
			activePiece = tmpPiece;

			activeIV = tmpIV;
			[imageIV setFrame:tmpIV.frame];
			[imageIV setImage:tmpIV.image];
			[tmpIV setHidden:YES];
			[imageIV setHidden:NO];
		
			[self.view bringSubviewToFront:imageIV];
			[tmpPiece release];
			return;
			
			
		}
	}

	[tmpPiece release];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (gameIsOver) {
		return;
	}
	if (activePiece.white != whiteToMove) {
		return;
	}
	UITouch *touch = [touches anyObject];
	if ([touch view] == activeIV) {
		CGPoint location = [touch locationInView:self.view];
		imageIV.center = location;
		return;
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (gameIsOver) {
		return;
	}
	if (activePiece.white != whiteToMove) {
		return;
	}

	UITouch *touch = [touches anyObject];
	NSString *key = [self closestSquareToPoint:[touch locationInView:self.view]];

	
	activeMove.aPiece = activePiece;
	[activeMove.startSquare setString:activePiece.square];
	

	NSArray *tmpArray;
	if (whiteToMove) {
		tmpArray = blackPieces;
	}
	else {
		tmpArray = whitePieces;
	}


	[(UIImageView *)[squareDict objectForKey:activePiece.square] setHidden:NO];
	[activeMove.endSquare setString:key];

	int enPassantRow;
	if (activeMove.aPiece.white) {
		enPassantRow = 5;
	}
	else {
		enPassantRow = 4;
	}
	if ([activeMove.aPiece.square isEqualToString:key] ) {
		imageIV.image = nil;
		return;
	}

	if (((UIImageView *)[squareDict objectForKey:key]).image || (
		(abs([key characterAtIndex:0] - [activePiece.square characterAtIndex:0]) == 1) && 
		([activeMove.aPiece.name isEqual:@"P"] && 
		 [activeMove.aPiece.square characterAtIndex:1] - '0' == enPassantRow))) {

		//look inside array to make sure there's a piece there.

		if (((UIImageView *)[squareDict objectForKey:key]).image) {
			for (int i = 0; i < [tmpArray count]; i ++) {
				if ([((Piece *)[tmpArray objectAtIndex:i]).square isEqual: key]) {
					activeMove.take = YES;
					[activeMove.pieceTaken setString:((Piece *)[tmpArray objectAtIndex:i]).name];
					break;
					
				}
			}
		}
		else {
			
			activeMove.enPassant = YES;
			for (int i = 0; i < [tmpArray count]; i++) {
				if ([((Piece *)[tmpArray objectAtIndex:i]).square isEqual:key]) {
					activeMove.take = YES;
					[activeMove.pieceTaken setString:((Piece *)[tmpArray objectAtIndex:i]).name];
					activeMove.enPassant = NO;
					break;
				}
			}
			if (activeMove.enPassant) {
				for (int i = 0; i < [tmpArray count]; i++) {
					NSString *tmpSquare = [[NSString alloc] initWithString:((Piece *)[tmpArray objectAtIndex:i]).square];
					if ([tmpSquare characterAtIndex:0] == [activeMove.endSquare characterAtIndex:0] && 
						[tmpSquare characterAtIndex:1] == [activeMove.endSquare characterAtIndex:1] - [activeMove.aPiece getForwardDirection]) {
						activeMove.take = YES;
						[activeMove.pieceTaken setString:@"P"];
						break;
					}
				}
			}
		}

		if (!activeMove.take) {
			//invalid
			imageIV.image = nil;
			return;
		}


	}
	else if ([activePiece.name isEqual:@"K"]) {
		//check for castling
		if (whiteToMove) {
			if ([activePiece.square isEqual:@"e1"]) {
				if ([activeMove.endSquare isEqual:@"g1"]) {
					activeMove.kCastle = YES;
				}
				else if ([activeMove.endSquare isEqual:@"c1"]) {
					activeMove.qCastle = YES;
				}
			}
		}
		else {
			if ([activePiece.square isEqual:@"e8"]) {
				if ([activeMove.endSquare isEqual:@"g8"]) {
					activeMove.kCastle = YES;
				}
				else if ([activeMove.endSquare isEqual:@"c8"]) {
					activeMove.qCastle = YES;
				}
			}
		}
	}
	int lastRow;
	if (activePiece.white) {
		lastRow = 8;
	}
	else {
		lastRow = 1;
	}
	if ([self piece:activePiece canMakeMove:activeMove checkForCheck:YES]) {
		//((UIImageView *)[squareDict objectForKey:activePiece.square]).image = nil;

	
		//check if promotion
		int endRow;
		if (activeMove.aPiece.white) {
			endRow = 8;
		}
		else {
			endRow = 1;
		}
		if (activePiece.white) {
			moveNumber ++;
			activeMove.moveNumber = moveNumber;
		}
		else {
			activeMove.moveNumber = moveNumber;
		}
	
		if ([activeMove.aPiece.name isEqual:@"P"] && [activeMove.endSquare characterAtIndex:1] - '0' == endRow) {
			///is a promotion
			//show alert
			activeMove.promote = YES;
			/*
			UIAlertView *promotionAlert = [[UIAlertView alloc] initWithTitle:@"Promote Pawn" 
																	 message:@"Select a piece." 
																	delegate:self 
														   cancelButtonTitle:nil 
														   otherButtonTitles:@"Queen", @"Rook", @"Bishop", @"Knight",nil, nil];
			 
			promotionAlert.tag = 1;
			[promotionAlert show];
			[promotionAlert release];
			*/
			[self.view addSubview:promView];
			[self setPromoteButtons];
		}
		else {
			[self makeMove];
		}
		imageIV.image = nil;
        //[activeMove resetValues];
	}
	else {
		imageIV.image = nil;
        [activeMove resetValues];
	}

}

- (void) makeMove {
	NSArray *tmpArray;
	Piece *tmpPiece = [[Piece alloc] init];
	if (activePiece.white) {
		tmpArray = whitePieces;
	}
	else {
		tmpArray = blackPieces;
	}
	for (int i = 0; i < [tmpArray count]; i ++) {
		tmpPiece = [tmpArray objectAtIndex:i];
		if ([tmpPiece.square isEqualToString:activePiece.square]) {
			break;
		}
	}
	activeMove.aPiece = tmpPiece;
	Move *tmpMove;
	tmpMove = activeMove;
    [self playSound];
	[self movePiece:tmpPiece withMove:tmpMove];
	tmpMove = nil;
	tmpPiece = nil;

	
	Move *newMove = [[Move alloc] init];
	[newMove initialize];
	[newMove setMoveWithMove:activeMove];
	while ([movesMade count] < [movesArray count]) {
		[movesArray removeLastObject];
	}
	[movesArray addObject:newMove];
	[movesMade addObject:newMove];
    [activeMove resetValues];
	if ([self isInCheck:!whiteToMove withMove:activeMove]) {
		newMove.check = YES;
		
	}
	
    //check for stalemate or checkmate. (see if opposing player can make a valid move)
    if ([self isInCheckmate:!whiteToMove]) {
        if (newMove.check) {
            newMove.check = NO;
            newMove.checkmate = YES;
            gameIsOver = YES;
            if (whiteToMove) {
                [self gameIsOver:'W'];
            }
            else {
                [self gameIsOver:'B'];
            }
            NSLog(@"checkmate!!");
            NSString *tmpString;
            if (newMove.aPiece.white) {
                tmpString = [[NSString alloc] initWithString:@"White won!"];
            }
            else {
                tmpString = [[NSString alloc] initWithString:@"Black won!"];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                            message:tmpString
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
            [alert release];
        }
        else {
            gameIsOver = YES;
            NSLog(@"stalemate!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" 
                                                            message:@"Stalemate" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }

    }

	[self addMoveToComments:newMove];
	[newMove release];
    if (moveCount && !backButton.enabled ) {
        [backButton setEnabled:YES];
    }
    [forwardButton setEnabled:NO];
	
	[activeMove resetValues];
	whiteToMove = !whiteToMove;
}

- (void) resign:(BOOL)whiteResigns {
    if (whiteToMove) {
        moveNumber ++;
    }
    whiteToMove = !whiteToMove;
    activeMove.moveNumber  = moveNumber;
    activeMove.aPiece.white = whiteResigns;
    activeMove.resign = YES;
    gameIsOver = YES;
    NSString *tmpMessage;
    if (whiteResigns) {
        [self gameIsOver:'B'];
        tmpMessage = [[NSString alloc] initWithString:@"White resigned"];
    }
    else {
        [self gameIsOver:'W'];
        tmpMessage = [[NSString alloc] initWithString:@"Black resigned"];
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
    


    Move *newMove = [[Move alloc] init];
	[newMove initialize];
	[newMove setMoveWithMove:activeMove];
	[self movePiece:nil withMove:newMove];
    [self addMoveToComments:newMove];
    while ([movesMade count] < [movesArray count]) {
		[movesArray removeLastObject];
	}
  
    [movesMade addObject:newMove];
    [movesArray addObject:newMove];
    [newMove release];

    [activeMove resetValues];
 
}

-(void) draw {
    if (whiteToMove) {
        moveNumber ++;
    }
    whiteToMove = !whiteToMove;
    activeMove.moveNumber = moveNumber;
    activeMove.draw = YES;
    gameIsOver = YES;
    
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
        
    
    [self gameIsOver:'D'];
    Move *newMove = [[Move alloc] init];
	[newMove initialize];
	[newMove setMoveWithMove:activeMove];
	[self movePiece:nil withMove:newMove];
    [self addMoveToComments:newMove];
    while ([movesMade count] < [movesArray count]) {
		[movesArray removeLastObject];
	}
    
    [movesMade addObject:newMove];
    [movesArray addObject:newMove];
    [newMove release];
    
    [activeMove resetValues];
    
}


/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1) {
		switch (buttonIndex) {
			case 0:
			{
				[activeMove.promotePiece setString:@"Q"];
				break;
			}
			case 1:
			{
				[activeMove.promotePiece setString:@"R"];
				break;
			}
			case 2:
			{
				[activeMove.promotePiece setString:@"B"];
				break;
			}
			case 3:
			{
				[activeMove.promotePiece setString:@"N"];
				break;
			}
				
				
				
			default:
				break;
		}
		
		[self makeMove];
	}

}*/


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

- (IBAction) backAction:(id)sender {
    if ([movesMade count] == 0) {
        return;
    }
	gameIsOver = NO;
    [self gameIsOver:'N'];
	
	if (whiteToMove) {
		//last move was black
	}
	else {
		moveNumber --;
	}
/*
    if (((Move *)[movesMade lastObject]).resign || ((Move *)[movesMade lastObject]).draw) {
        //white to move doesn't change
    }
    else {
        whiteToMove = !whiteToMove;
    }	*/ 
    whiteToMove = !whiteToMove;
	[self removeLastMoveAndComment:YES];
    [self playSound];
    if (moveNumber == 0) {
        [backButton setEnabled:NO];
    }
    if ([movesArray count]) {
        [forwardButton setEnabled:YES];
    }
   
}

- (IBAction) forwardAction:(id)sender {
	if ([movesMade count] == [movesArray count]) {
		return;
	}
	[self carryOutMove];
	if (whiteToMove) {
		//white makes a move
		moveNumber ++;
	}
	else {
		//nothing
	}
    /*
    if (((Move *)[movesArray objectAtIndex:[movesMade count] - 1]).resign || ((Move *)[movesArray objectAtIndex:[movesMade count] - 1]).draw) {
        //white to move doesn't change
    }
    else {
        whiteToMove = !whiteToMove;
    }*/
    whiteToMove = !whiteToMove;
    if (!backButton.enabled) {
        [backButton setEnabled:YES];
    }
    if ([movesMade count] == [movesArray count]) {
        //last move
        [forwardButton setEnabled:NO];
    }


}

-(IBAction)optionsAction:(id)sender {
    //this will be overridden
    if (gameIsOver) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Flip Board", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet setTag:0];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Flip Board", @"Draw", @"White Resign", @"Black Resign", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet setTag:0];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }

}

-(IBAction) promotePieceAction:(id)sender {
	[promView removeFromSuperview];
	switch (((UIButton *)sender).tag) {
		case 0:
		{
			[activeMove.promotePiece setString:@"Q"];
			break;
		}
		case 1:
		{
			[activeMove.promotePiece setString:@"R"];
			break;
		}
		case 2:
		{
			[activeMove.promotePiece setString:@"B"];
			break;
		}
		case 3:
		{
			[activeMove.promotePiece setString:@"N"];
			break;
		}		
		default:
			break;
			
	}
	[self makeMove];

	
}

-(void) buildPromotionView {
	promView = [[UIView alloc] initWithFrame:self.view.frame];
	[promView setBackgroundColor:[UIColor clearColor]];
	UITextView *backView = [[UITextView alloc] initWithFrame:CGRectMake(0, 140, 320, 140)];
	[backView setText:@"Choose a piece to promote to"];
	[backView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
	[backView setTextAlignment:UITextAlignmentCenter];
	[backView setBackgroundColor:[UIColor whiteColor]];
	[promView addSubview:backView];

	CGRect rect = CGRectMake(10, 200, 60, 60);
	for (int i = 0; i < 4; i ++) {
		UIButton *promButton = [UIButton buttonWithType:UIButtonTypeCustom];
		promButton.tag = i;
		[promButton addTarget:self action:@selector(promotePieceAction:) forControlEvents:UIControlEventTouchUpInside];
		[promButton setFrame:rect];
		[promView addSubview:promButton];
		rect.origin.x += 80;
		
	}
	
	//[self.view addSubview:promView];
	
	
}

-(void) setPromoteButtons {
	NSArray *promotePieces = [[NSArray alloc] initWithObjects:@"queen", @"rook", @"bishop", @"knight", nil];
	NSMutableString *pieceFile = [[NSMutableString alloc] init];
	NSString *prefix;
	if (whiteToMove) {
		prefix = [[NSString alloc] initWithString:@"w_"];
	}
	else {
		prefix = [[NSString alloc] initWithString:@"b_"];
	}
	NSLog(@"promView.subview %@", promView.subviews);
	for (int i = 0; i < [promView.subviews count]; i++) {
		NSLog(@"class %@", [[promView.subviews objectAtIndex:i] class]);
		if ([[[promView.subviews objectAtIndex:i] class] isEqual:[UIButton class]] ) {
			[pieceFile setString:[NSString stringWithFormat:@"%@%@", prefix, [promotePieces objectAtIndex:i - 1]]];
			[(UIButton *)[promView.subviews objectAtIndex:i] setImage:[UIImage imageNamed:pieceFile] forState:UIControlStateNormal];
			
		}
	}
	[promotePieces release];
	[pieceFile release];
	[prefix release];
}


@end
