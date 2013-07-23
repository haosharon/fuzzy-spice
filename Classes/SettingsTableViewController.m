//
//  SettingsTableViewController.m
//  How To Chess
//
//  Created by Sharon Hao on 7/28/11.
//  Copyright 2011 s.hao All rights reserved.
//

#import "SettingsTableViewController.h"


@implementation SettingsTableViewController

@synthesize settingsDict;
@synthesize propNames, properties;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	/*
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if ([prefs objectForKey:@"Settings"]) {
		settingsDict = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"Settings"]];
		propNames = [[NSMutableArray alloc] initWithArray:[settingsDict allKeys]];
		properties = [[NSMutableArray alloc] initWithArray:[settingsDict allValues]];
	}
	else {
		propNames = [[NSMutableArray alloc] initWithObjects:@"Name", @"Rating", @"Email", nil];
		properties = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
		settingsDict = [[NSMutableDictionary alloc] initWithObjects:properties forKeys:propNames];
	}
    */
    const float RED = 100;
    const float GREEN = 0;
    const float BLUE = 0;
    soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [soundSwitch addTarget:self action:@selector(soundChanged:) forControlEvents:UIControlEventValueChanged];

    [self.tableView setBackgroundColor:[UIColor colorWithRed:RED/255 green:GREEN/255 blue:BLUE/255 alpha:1.0]];
	
	

	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
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

-(IBAction) goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)soundChanged:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL soundIsOff = [prefs boolForKey:@"soundOff"];///if soundOff is true, then sound is off (switch is off). when app starts, soundOff == NO
    soundIsOff = !soundIsOff;
    [prefs setBool:soundIsOff forKey:@"soundOff"];
}


#pragma mark -
#pragma mark Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 100;
    }
    else {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 1;
    }
    else {
        return 1;
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Chess Saver 1.0"];
			[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
        }
        else {
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 305, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
            NSString *description = [[NSString alloc] initWithFormat:@"Chess Saver for iPhone allows competitive chess players to record, save, and email their games for review later. As this is a beta app, any questions, comments, or concerns are greatly appreciated."];
            [tv setText:description];
            [tv setScrollEnabled:NO];
            [description release];
            
            //[cell setAccessoryView:tv];
            [tv setBackgroundColor:[UIColor clearColor]];
            [tv setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [tv setTextAlignment:UITextAlignmentLeft];
            [cell.contentView addSubview:tv];
            [tv setEditable:NO];
            
            [tv release];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            
        }
    }
    else if (indexPath.section == 1){
       
        [cell.textLabel setText:@"Send Feedback"];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        [cell.textLabel setText:@"Sound"];
        [cell setAccessoryView:soundSwitch];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        BOOL soundOff = [prefs boolForKey:@"soundOff"];
        if (soundOff) {
            //sound is off, switch should be off
            [soundSwitch setOn:NO];
        }
        else {
            //sound is on, switch should be on
            [soundSwitch setOn:YES];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
    /*
    if (indexPath.section == 0) {
        [cell.textLabel setText:[propNames objectAtIndex:indexPath.row]];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
        if ([[properties objectAtIndex:indexPath.row] length] > 0) {
            [textField setText:[properties objectAtIndex:indexPath.row]];
        }
        else {
            [textField setText:@""];
            if ([[propNames objectAtIndex:indexPath.row] isEqual:@"Name"]) {
                [textField setPlaceholder:@"Required"];
                
            }
        }
        
        [cell setAccessoryView:textField];
    }
    else {
        [cell.textLabel setText:@"Sound"];
        [cell setAccessoryView:soundSwitch];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        BOOL soundOff = [prefs boolForKey:@"soundOff"];
        if (soundOff) {
            //sound is off, switch should be off
            [soundSwitch setOn:NO];
        }
        else {
            //sound is on, switch should be on
            [soundSwitch setOn:YES];
        }
        
        
        
    }
     */

    
    // Configure the cell...
    
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        
        //email
        if ([MFMailComposeViewController canSendMail]) {
            //do somtenhig
            
            MFMailComposeViewController *mComposer = [[MFMailComposeViewController alloc] init];
            [mComposer setMailComposeDelegate:self];
            [mComposer setToRecipients:[NSArray arrayWithObject:@"hsharon@mit.edu"]];
            [mComposer setSubject:@"Chess Saver: Questions, comments, concerns.."];
            [mComposer setMessageBody:@"Dear Sharon, \nThis is what I think about your Chess Saver app:" isHTML:NO];
            [self presentModalViewController:mComposer animated:YES];
            
            [mComposer release];
            
        }
        
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissModalViewControllerAnimated:YES];
    
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
    [soundSwitch release];
}


@end

