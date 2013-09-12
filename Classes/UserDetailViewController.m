//
//  UserDetailViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/18/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "UserDetailViewController.h"
#import "NSDate+Utilities.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>


#define kCellMargin             20.0
#define kDetailLabelWidth       210.0
#define kDetailLabelFontSize    15.0



@interface UserDetailViewController ()
@property (nonatomic, strong) NSOperationQueue* queue;
@end



@implementation UserDetailViewController



- (void)viewDidLoad
{
    self.title = @"Profile";
    self.nameLabel.text = self.user.name;
    
    NSArray* possibleKeys = @[@"gender", @"birthday", @"relationship_status", @"hometown", @"location", @"updated_time", @"locale"];

    NSMutableArray* existKeys = [NSMutableArray arrayWithCapacity:[possibleKeys count]];
    for ( id keyPath in possibleKeys )
    {
        if ( [self.user valueForKey:keyPath] )
        {
            [existKeys addObject:keyPath];
        }
    }
    
    self.keyPaths = [NSMutableArray arrayWithCapacity:3];
    self.works = [self.user sortedWorks];
    self.educations = [self.user sortedEducations];
    
    if ( [existKeys count] ) [self.keyPaths addObject:existKeys];    
    if ( [self.works count] ) [self.keyPaths addObject:self.works];    
    if ( [self.educations count] ) [self.keyPaths addObject:self.educations];    

    
    NSString* avatar = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.user.id];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:nil];

//    [self.profileImageView setImageWithURL:[NSURL URLWithString:avatar]
//                          placeholderImage:nil
//                                   success:^(UIImage *image, BOOL cached) {
//                                       
//                                       CGFloat width = self.profileImageView.bounds.size.width;
//                                       CGFloat ratio = width / image.size.width;
//                                       CGFloat height = image.size.height * ratio;
//                                       self.profileImageView.bounds = CGRectMake(0, 0, width, height);
//                                       
//                                       CALayer* layer = self.profileImageView.layer;
//                                       layer.masksToBounds = YES;
//                                       layer.cornerRadius = 10.0;
//                                       layer.borderWidth = 1.0;
//                                       layer.borderColor = [UIColor darkGrayColor].CGColor;
//                                       
//                                   } failure:^(NSError *error) {
//                                       
//                                       NSLog(@"Failed to load image: %@", error);
//                                   }];

    
    [super viewDidLoad];
}

- (void)dealloc
{
    [self.queue cancelAllOperations];

}

- (NSDictionary*)displayNameDict
{
    if ( !_displayNameDict )
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"attributeDisplayNames" ofType:@"plist"];
        _displayNameDict = [NSDictionary dictionaryWithContentsOfFile:path][@"Root"];
    }
    return _displayNameDict;
}

- (IBAction)openProfilePageLink
{
    NSURL* url = [NSURL URLWithString:self.user.link];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keyPaths count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.keyPaths[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* section = self.keyPaths[indexPath.section];

    if ( section == self.works )
    {
        Work* work = self.works[indexPath.row];
        NSString* text = [self descriptionForWork:work];
        CGFloat height = kCellMargin + [text sizeWithFont:[UIFont boldSystemFontOfSize:kDetailLabelFontSize] 
                                        constrainedToSize:CGSizeMake(kDetailLabelWidth, 200)
                                            lineBreakMode:NSLineBreakByWordWrapping].height;
        return height;
    }
    else if ( section == self.educations )
    {
        Education* education = self.educations[indexPath.row];
        NSString* text = [self descriptionForEducation:education];
        CGFloat height = kCellMargin + [text sizeWithFont:[UIFont boldSystemFontOfSize:kDetailLabelFontSize] 
                                        constrainedToSize:CGSizeMake(kDetailLabelWidth, 200)
                                            lineBreakMode:NSLineBreakByWordWrapping].height;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    NSArray* section = self.keyPaths[indexPath.section];
    
    if ( section == self.works )
    {
        Work* work = self.works[indexPath.row];
        cell.textLabel.text = @"Work";
        cell.detailTextLabel.text = [self descriptionForWork:work];
    }
    else if ( section == self.educations )
    {
        Education* education = self.educations[indexPath.row];
        cell.textLabel.text = @"Education";
        cell.detailTextLabel.text = [self descriptionForEducation:education];
    }
    else
    {
        NSString* keyPath = section[indexPath.row];
        id value = [self.user valueForKey:keyPath];
        
        cell.textLabel.text = (self.displayNameDict)[keyPath];
        
        if ( [value isKindOfClass:[NSString class]] )
        {
            cell.detailTextLabel.text = value;
        }
        
        else if ( [keyPath isEqualToString:@"birthday"] )
        {
            if ( self.user.birthdayYear )
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@/%@", self.user.birthdayYear, self.user.birthdayMonth, self.user.birthdayDay];
            }
            else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@", self.user.birthdayMonth, self.user.birthdayDay];                
            }
        }
        
        else if ( [keyPath isEqualToString:@"updated_time"] )
        {
            cell.detailTextLabel.text = [self.user.updated_time stringFromDate]; 
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
