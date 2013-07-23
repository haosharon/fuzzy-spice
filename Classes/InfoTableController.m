//
//  InfoTableController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/25/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "InfoTableController.h"
#import "InfoTableCommentCell.h"
#import "NewGameViewController.h"

const int KEYBOARD_HEIGHT = 216;

@implementation InfoTableController

@synthesize gameInfo;
@synthesize parentController;
@synthesize myTableView;
@synthesize activeField;
@synthesize activeView;
@synthesize game;
@synthesize state;
@synthesize comments;
@synthesize newState;
//@synthesize tableContainer;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	//gameInfo = [[NSMutableDictionary alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    if (game) {
        mandatoryProp = [[NSArray alloc] initWithObjects:@"Date", @"White", @"Black", @"Result", nil];
        propNames = [[NSMutableArray alloc] initWithArray:[game.gameInfo allKeys]];
        properties = [[NSMutableArray alloc] initWithArray:[game.gameInfo allValues]];
        comments = [[NSMutableString alloc] initWithString:game.comments];
        ///check to make sure properties date, white, black, and result are there.
        int index;
        for (int i = 0; i < [mandatoryProp count]; i++) {
            NSString *tmpProp = [[NSString alloc] initWithString:[mandatoryProp objectAtIndex:i]];
            NSLog(@"tmpProp %@", tmpProp);
            index = [propNames indexOfObject:tmpProp];
            if (index == NSNotFound) {
                [propNames insertObject:tmpProp atIndex:i];
                [properties insertObject:@"" atIndex:i];
            }
            else if (index != i) {
                [propNames exchangeObjectAtIndex:index withObjectAtIndex:i];
                [properties exchangeObjectAtIndex:index withObjectAtIndex:i];
            }
        }
    }
    else {
        ///do stuff with state
        if (newState) {
            mandatoryProp = [[NSArray alloc] initWithObjects:@"Title", @"Date", @"Next Move", nil];

        }
        else {
            mandatoryProp = [[NSArray alloc] initWithObjects:@"Title", @"Date", nil];
        }
        propNames = [[NSMutableArray alloc] initWithArray:[state.stateInfo allKeys]];
        properties = [[NSMutableArray alloc] initWithArray:[state.stateInfo allValues]];
        comments = [[NSMutableString alloc] initWithString:state.comments];
        int index;
        for (int i = 0; i < [mandatoryProp count]; i++) {
            NSString *tmpProp = [[NSString alloc] initWithString:[mandatoryProp objectAtIndex:i]];
            NSLog(@"tmpProp %@", tmpProp);
            index = [propNames indexOfObject:tmpProp];
            if (index == NSNotFound) {
                [propNames insertObject:tmpProp atIndex:i];
                [properties insertObject:@"" atIndex:i];
            }
            else if (index != i) {
                [propNames exchangeObjectAtIndex:index withObjectAtIndex:i];
                [properties exchangeObjectAtIndex:index withObjectAtIndex:i];
            }
        }
    }

	
	const float RED = 100;
    const float GREEN = 0;
    const float BLUE = 0;
    [self.myTableView setBackgroundColor:[UIColor colorWithRed:RED/255 green:GREEN/255 blue:BLUE/255 alpha:1.0]];
	
	[self.myTableView setAllowsSelection:YES];
    [self.myTableView setAllowsSelectionDuringEditing:YES];
	//[self.tableView initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	[self registerForKeyboardNotifications];
	//[self.myTableView reloadData];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //check for result
    
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	if (activeField) {
		[activeField resignFirstResponder];
	}
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

- (void) setResult {
    if (game.result == 'N') {
        //result changed
        [game.gameInfo setObject:@"unknown" forKey:@"Result"];

    }
    else if (game.result == 'W') {
        [game.gameInfo setObject:@"1 - 0" forKey:@"Result"];
    }
    else if (game.result == 'B') {
        [game.gameInfo setObject:@"0 - 1" forKey:@"Result"];
    }
    else {
        [game.gameInfo setObject:@"1/2 - 1/2" forKey:@"Result"];
    }

}


- (void) saveGameInfo {
	
}

- (IBAction)changeNextMove:(id)sender {
    if (state) {
        state.whiteToMove = !state.whiteToMove;
    }
}


- (void)dismissKeyboard {
    if (activeView) {
        [activeView resignFirstResponder];
    }
    else if (activeField) {
        [activeField resignFirstResponder];
    }
    
}


- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
	if (keyboardIsShown) {
		[self resizeViewByHeight:KEYBOARD_HEIGHT];
	}
	keyboardIsShown = NO;
}
// called when the UIKeyboardDidShowNotification is sent
- (void)keyboardWasShown:(NSNotification *)aNotification
{

	if (keyboardIsShown) {
		return;
	}
	
	[self resizeViewByHeight:-KEYBOARD_HEIGHT];
    if (activeField) {
        [self scrollToTextFieldInView:activeField];
    }
    else if (activeView) {
        [self scrollToTextViewInView:activeView];
    }

	keyboardIsShown = YES;
    return;

	 
}

//textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeView = nil;
	activeField = textField;
    [self scrollToTextFieldInView:activeField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[properties replaceObjectAtIndex:textField.tag withObject:textField.text];
    if (game) {
        [game.gameInfo setObject:textField.text forKey:[propNames objectAtIndex:textField.tag]];
    }
    else {
        [state.stateInfo setObject:textField.text forKey:[propNames objectAtIndex:textField.tag]];
    }
 
	activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];

	return YES;
}

//this is written poorly...but it works
- (void) scrollToTextFieldInView:(UITextField*)textField {
    CGRect rect = [myTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
	[self.myTableView scrollRectToVisible:rect animated:YES];
	
}

- (void) scrollToTextViewInView:(UITextView *)textview {
    CGRect rect = [myTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [self.myTableView scrollRectToVisible:rect animated:YES];
}


- (void) resizeViewByHeight:(int)heightDiff {
	
	CGRect frame = self.myTableView.frame;
	frame.size.height += heightDiff;
	self.myTableView.frame = frame;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeField = nil;
    activeView = textView;
    [self scrollToTextViewInView:activeView];
    
}
- (void) textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    if (game) {
        [game.comments setString:textView.text];
        [comments setString:textView.text];
    }
    else {
        [comments setString:textView.text];
    }
    activeView = nil;
}

	  

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Game Info";
    }
    else if (section == 1){
        return @"Comments";
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [propNames count];
    }
    else {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 80;
    }
    else {
        return 44;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
    if (section != 2) {
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, 300.0, 44.0)];
        
        // create the button object
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        headerLabel.frame = CGRectMake(15.0, 0.0, 300.0, 44.0);
        
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        if (section == 0) {
            if (game) {
                [headerLabel setText:@"Game Info"];
            }
            else {
                [headerLabel setText:@"State Info"];
            }
        }
        else {
            [headerLabel setText:@"Comments"];
        }
        
        [customView addSubview:headerLabel];
        
        return customView;
    }
    else {
        return nil;
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"Cell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = nil;
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];

                if ([[propNames objectAtIndex:indexPath.row] isEqualToString:@"Next Move"]) {
                    UISegmentedControl *nextMoveSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"White to move", @"Black to move", nil]];
                    [nextMoveSeg setSegmentedControlStyle:UISegmentedControlStyleBar];
                    [nextMoveSeg setFrame:CGRectMake(10, 4, 280, 36)];
                    [nextMoveSeg setSelectedSegmentIndex:0];
                    [nextMoveSeg addTarget:self action:@selector(changeNextMove:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:nextMoveSeg];
                    
                }
                else {
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
                    if (indexPath.row <=2) {
                        if ([[properties objectAtIndex:indexPath.row] length] == 0) {
                            [textField setPlaceholder:@"Required"];
                        }
                        else {
                            [textField setText:[properties objectAtIndex:indexPath.row]];
                        }
                    }
                    else {
                        [textField setText:[game.gameInfo objectForKey:@"Result"]];
                        [textField setEnabled:NO];
                    }
                    
                    [textField setTextColor:[UIColor grayColor]];
                    [textField setFont:[UIFont systemFontOfSize:14]];
                    [textField setTag:indexPath.row];
                    textField.delegate = self;
                    cell.accessoryView = textField;
                    [textField release];
                    
                    
                    
                    cell.textLabel.backgroundColor = [UIColor clearColor];
                    cell.textLabel.opaque = NO;
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [propNames objectAtIndex:indexPath.row]]];
                    [cell setSelectedBackgroundView:nil];

                }
                
                
               
                                
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        case 1:
        {
            static NSString *CellIdentifier = @"InfoTableCommentCell";
            InfoTableCommentCell *cell = (InfoTableCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InfoTableCommentCell" owner:nil options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[InfoTableCommentCell class]]) {
                        cell = (InfoTableCommentCell *)currentObject;
                        break;
                    }
                }
            }
            if (game) {
                [cell.commentText setText:game.comments];
            }
            else {
                [cell.commentText setText:comments];
            }
            [cell.commentText setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
        case 2:
        {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = nil;
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                [cell.textLabel setText:@"Save/Send"];
                
            }
            
            return cell;
            
        }
        default:
            break;
    }
    
    return nil;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        ///open options actionsheet
        if (game) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save/Send"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Save Game", @"Save State", @"Email Game", nil];
            [actionSheet setTag:0];
            [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionSheet showInView:self.view];
            [actionSheet release];
        }
        else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save/Send"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Save State", @"Email State", nil];
            [actionSheet setTag:1];
            [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionSheet showInView:self.view];
            [actionSheet release];
        }

        
    }

}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 0) {
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"game %@", game.gameInfo);
                
                ///first double check that white, black, and result are filled.
                if ([[game.gameInfo objectForKey:@"White"] length] == 0 || [[game.gameInfo objectForKey:@"Black"] length] == 0) {
                    //add an alert to ask for info
                    UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Save Game" 
                                                                        message:@"All mandatory fields must be filled." 
                                                                       delegate:nil 
                                                              cancelButtonTitle:@"Ok" 
                                                              otherButtonTitles: nil];
                    [infoAlert show];
                    [infoAlert release];    
                }
                
                else {
                    [(NewGameViewController *)parentController saveGame:nil];
                }
                
                //save game
                
                break;
            }
            case 1:
            {
                [(BoardViewController *)parentController saveBoardStateAction];
                //save state
                break;
            }
            case 2:
            {
                [self emailGame:game];
                //email game
                break;
            }
                
            default:
                break;
        }
    }
    else if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
            {
                [(BoardViewController*)parentController saveBoardStateAction];
                //save state
                break;
            }
            case 1:
            {
                //email state...maybe
            }
                
            default:
                break;
        }
    }

    
}


- (void)emailGame:(Game *)gameToSend {
    //MFMailComposeViewController *mf;
    if ([MFMailComposeViewController canSendMail]) {
        //do somtenhig
        
        MFMailComposeViewController *mComposer = [[MFMailComposeViewController alloc] init];
        [mComposer setMailComposeDelegate:self];
        [mComposer setSubject:@"Game"];
        [mComposer setMessageBody:(NSString *)[gameToSend convertToString] isHTML:NO];
        self.parentController.navigationController.navigationBarHidden = YES;

        [self presentModalViewController:mComposer animated:YES];

        [mComposer release];
        
    }
    
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    CGFloat height = myTableView.frame.size.height; //preserve table height
    [controller dismissModalViewControllerAnimated:YES];
    myTableView.frame = CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, height);
    self.parentController.navigationController.navigationBarHidden = NO;

    if (result == MFMailComposeResultSent) {
        //sent
        NSLog(@"email sent");
        
    }
    else if (result == MFMailComposeResultCancelled) {
        //cancelled
        NSLog(@"email cancelled");
        
    }
    else if (result == MFMailComposeResultSaved) {
        //saved
        NSLog(@"email saved");
    }
    else {
        //error?
        NSLog(@"email error?");
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
	[gameInfo release];
	[propNames release];
	[properties release];
}


@end

