//
//  SearchResultViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/25/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "SearchResultViewController.h"


@implementation SearchResultViewController

@synthesize searchString, category, friendArray, requestArray, filteredArray;
@synthesize tableView, searchLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	searchLabel.text = [NSString stringWithFormat:@"Searching %@ in %@", searchString, category];
	
	[self fetchFriends];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[searchString release];
	[category release];
	[tableView release];
	[searchLabel release];
    [super dealloc];
}


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"Cell";
	
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	
	cell.textLabel.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


#pragma mark -
#pragma mark Facebook

- (void)fetchFriends
{
	friendRequest = [[FacebookClient sharedFacebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)parseFriends
{
	self.requestArray = [NSMutableArray arrayWithCapacity:[friendArray count]];
	self.filteredArray = [NSMutableArray arrayWithCapacity:[friendArray count]];
	
	for ( id user in self.friendArray )
	{
		NSString* userID = [user objectForKey:@"id"];
		FBRequest* request = [[FacebookClient sharedFacebook] requestWithGraphPath:userID andDelegate:self];
		
		[requestArray addObject:request];
	}
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result
{
	if ( request == friendRequest )
	{
		self.friendArray = [result objectForKey:@"data"];
		[self parseFriends];
	}
	else if ( [requestArray containsObject:request] )
	{
		NSString* value = [result objectForKey:category];
		if ( [searchString isEqualToString:value] )
		{
			[filteredArray addObject:result];
		}
		[requestArray removeObject:request];
		
		if ( [requestArray count] == 0 )
		{
			[self.tableView reloadData];
			
			searchLabel.text = [NSString stringWithFormat:@"Found %d results", [filteredArray count]];
		}
	}
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"FBRequest failed with error: %@", error);
}


@end
