//
//  How_To_ChessAppDelegate.m
//  How To Chess
//
//  Created by Sharon Hao on 7/12/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "How_To_ChessAppDelegate.h"
#import "BoardState.h"
#import "Piece.h"

@implementation How_To_ChessAppDelegate

@synthesize mainTable ,window;
@synthesize navigationController;
//@synthesize tabBarController, window;

#pragma mark -
#pragma mark Application lifecycle

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    return YES;
}
*/

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    //[navigationController.navigationBar setTranslucent:NO];
    //[navigationController.navigationBar setTintColor:nil];
    
    [navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
	[navigationController.navigationBar setTintColor:[UIColor blackColor]];
	[window addSubview:navigationController.view];
	mainTable.view.frame = navigationController.view.frame;
	//[window addSubview:mainTable.view];
	//[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	[self setRegularBoardState];
	
	
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	//[navigationController release];
    [window release];
    [super dealloc];
}


- (void)setRegularBoardState {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *theData = [prefs objectForKey:@"Saved States"];
	NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:theData]];
	//NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	if ([dataArray count] == 0) {
		NSString *tmpString = [[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"setup" ofType:@"txt"]] autorelease];
		NSArray *tmpArray = [tmpString componentsSeparatedByString:@"\n"];
		NSArray *tmpPieces = [[[NSArray alloc] init] autorelease];
		NSMutableString *tmp = [[[NSMutableString alloc] init] autorelease];
		NSMutableArray *pieces = [[NSMutableArray alloc] initWithCapacity:16];
		NSMutableDictionary *stateInfo = [[NSMutableDictionary alloc] init];
		[stateInfo setObject:@"Regular Setup" forKey:@"Title"];
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
        [stateInfo setObject:[dateFormatter stringFromDate:now] forKey:@"Date"];
        [dateFormatter release];
		BoardState *state = [[BoardState alloc] init];
		for (int i = 0; i < 2; i ++) {
			tmpPieces = [[tmpArray objectAtIndex:i] componentsSeparatedByString:@", "];
			NSLog(@"tmp pieces %@", tmpPieces);
			for (int x = 0; x < [tmpPieces count]; x ++) {
				tmp = [NSMutableString stringWithString:[tmpPieces objectAtIndex:x]];
				Piece *piece = [[Piece alloc] init];
				if ([[tmpPieces objectAtIndex:x] length] == 2) {
					[piece.name setString:@"P"];
				}
				else {
					[piece.name setString:[NSString stringWithFormat:@"%c", [tmp characterAtIndex:0]]];
					[tmp deleteCharactersInRange:NSMakeRange(0, 1)];
				}
				[piece.square setString:tmp];
				
				if (i == 0) {
					piece.white = YES;
				}
				else {
					piece.white = NO;
				}
				[pieces addObject:piece];
				
			}
		}
		state.piecesArray = pieces;
		state.stateInfo = stateInfo;
		state.whiteToMove = YES;
        [state.comments setString:@""];
		[state.stateID setString:[state getRandomNumber]];
		NSMutableArray *savedStateIDs;
		savedStateIDs = [[NSMutableArray alloc] initWithObjects:state.stateID, nil];
		[prefs setObject:savedStateIDs forKey:@"Saved State IDs"];
		
		dataArray = [[NSMutableArray alloc] initWithObjects:state, nil];
		NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:dataArray];
		[prefs setObject:newData forKey:@"Saved States"];
		[pieces release];
	}
	///build board state for regular set up.
	
}

@end
/*
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
    UIColor *color = [UIColor blackColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    CGContextFillRect(context, rect);
    self.tintColor = color;
}
@end
*/
