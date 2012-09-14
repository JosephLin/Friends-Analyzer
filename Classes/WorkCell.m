//
//  WorkTableViewCell.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "WorkCell.h"
#import "User.h"



@implementation WorkCell


- (void)setWork:(Work *)theWork
{
    _work = theWork;
    
    NSAttributedString* nameString =
    [[NSAttributedString alloc] initWithString:[_work.user.name stringByAppendingString:@"\n"]
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSAttributedString* employerString =
    [[NSAttributedString alloc] initWithString:[_work.employer.name stringByAppendingString:@"\n"]
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
    if (_work.position.name) [array addObject:_work.position.name];
    if ([_work workDate]) [array addObject:[_work workDate]];
    if ( _work.location ) [array addObject:_work.location];
    
    NSAttributedString* descriptionString =
    [[NSAttributedString alloc] initWithString:[array componentsJoinedByString:@"\n"]
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0], NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    NSMutableAttributedString* attrString = [NSMutableAttributedString new];
    [attrString appendAttributedString:nameString];
    [attrString appendAttributedString:employerString];
    [attrString appendAttributedString:descriptionString];
    
    self.textLabel.attributedText = attrString;
}


@end
