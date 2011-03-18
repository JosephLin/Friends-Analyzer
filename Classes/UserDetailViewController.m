//
//  UserDetailViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserDetailViewController.h"
#import "NSDate+Utilities.h"

#define kCellMargin             20.0
#define kDetailLabelWidth       210.0
#define kDetailLabelFontSize    15.0


@implementation UserDetailViewController

@synthesize user;
@synthesize keyPaths, works, educations;
@synthesize displayNameDict;



- (void)viewDidLoad
{
    self.title = user.name;
    
    NSArray* possibleKeys = [NSArray arrayWithObjects:@"gender", @"birthday", @"relationship_status", @"hometown", @"location", @"updated_time", @"locale", nil];

    NSMutableArray* existKeys = [NSMutableArray arrayWithCapacity:[possibleKeys count]];
    for ( id keyPath in possibleKeys )
    {
        if ( [user valueForKey:keyPath] )
        {
            [existKeys addObject:keyPath];
        }
    }
    
    self.keyPaths = [NSMutableArray arrayWithCapacity:3];
    self.works = [user sortedWorks];
    self.educations = [user sortedEducations];
    
    if ( [possibleKeys count] ) [keyPaths addObject:possibleKeys];    
    if ( [self.works count] ) [keyPaths addObject:self.works];    
    if ( [self.educations count] ) [keyPaths addObject:self.educations];    

    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [user release];
    [keyPaths release];
    [works release];
    [educations release];
    [displayNameDict release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSDictionary*)displayNameDict
{
    if ( !displayNameDict )
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"attributeDisplayNames" ofType:@"plist"];
        displayNameDict = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Root"] retain];
    }
    return displayNameDict;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keyPaths count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [[keyPaths objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* section = [keyPaths objectAtIndex:indexPath.section];

    if ( section == self.works )
    {
        Work* work = [works objectAtIndex:indexPath.row];
        NSString* text = [self descriptionForWork:work];
        CGFloat height = kCellMargin + [text sizeWithFont:[UIFont boldSystemFontOfSize:kDetailLabelFontSize] 
                                        constrainedToSize:CGSizeMake(kDetailLabelWidth, 200)
                                            lineBreakMode:UILineBreakModeWordWrap].height;
        return height;
    }
    else if ( section == self.educations )
    {
        Education* education = [educations objectAtIndex:indexPath.row];
        NSString* text = [self descriptionForEducation:education];
        CGFloat height = kCellMargin + [text sizeWithFont:[UIFont boldSystemFontOfSize:kDetailLabelFontSize] 
                                        constrainedToSize:CGSizeMake(kDetailLabelWidth, 200)
                                            lineBreakMode:UILineBreakModeWordWrap].height;
        return height;
    }
    else
    {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    NSArray* section = [keyPaths objectAtIndex:indexPath.section];
    
    if ( section == self.works )
    {
        Work* work = [works objectAtIndex:indexPath.row];
        cell.textLabel.text = @"Work";
        cell.detailTextLabel.text = [self descriptionForWork:work];
    }
    else if ( section == self.educations )
    {
        Education* education = [educations objectAtIndex:indexPath.row];
        cell.textLabel.text = @"Education";
        cell.detailTextLabel.text = [self descriptionForEducation:education];
    }
    else
    {
        NSString* keyPath = [section objectAtIndex:indexPath.row];
        id value = [user valueForKey:keyPath];
        
        cell.textLabel.text = [self.displayNameDict objectForKey:keyPath];
        
        if ( [value isKindOfClass:[NSString class]] )
        {
            cell.detailTextLabel.text = value;
        }
        
        else if ( [keyPath isEqualToString:@"birthday"] )
        {
            if ( user.birthdayYear )
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@/%@", user.birthdayYear, user.birthdayMonth, user.birthdayDay];
            }
            else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@", user.birthdayMonth, user.birthdayDay];                
            }
        }
        
        else if ( [keyPath isEqualToString:@"updated_time"] )
        {
            cell.detailTextLabel.text = [user.updated_time stringFromDate]; 
        }
        
        else
        {
            cell.detailTextLabel.text = nil;
        }
    }
    
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    return nil;
}


- (NSString*)descriptionForWork:(Work*)work
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:4];
    if ( work.employer ) [array addObject:work.employer.name];
    if ( work.position ) [array addObject:work.position.name];
    if ( [work workDate] ) [array addObject:[work workDate]];
    if ( work.location ) [array addObject:work.location];
    
    NSString* string = [array componentsJoinedByString:@"\n"];
    return string;
}

- (NSString*)descriptionForEducation:(Education*)education
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:4];
    if ( education.school ) [array addObject:education.school.name];
    if ( education.year ) [array addObject:education.year];
    if ( education.degree ) [array addObject:education.degree.name];
    if ( education.concentrations )
    {
        for ( ObjectAttribute* object in education.concentrations )
        {
            [array addObject:object.name];
        }
    }
    
    NSString* string = [array componentsJoinedByString:@"\n"];
    return string;
}




@end
