//
//  EducationTableViewCell.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "EducationCell.h"
#import "User.h"



@implementation EducationCell


- (void)setEducation:(Education *)theEducation
{
    _education = theEducation;
    
    NSAttributedString* nameString =
    [[NSAttributedString alloc] initWithString:[_education.user.name stringByAppendingString:@"\n"]
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSAttributedString* schoolString =
    [[NSAttributedString alloc] initWithString:[_education.school.name stringByAppendingString:@"\n"]
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
    if ( _education.year ) [array addObject:_education.year];
    if ( _education.degree ) [array addObject:_education .degree.name];
    if ( _education.concentrations )
    {
        for ( ObjectAttribute* object in _education.concentrations )
        {
            [array addObject:object.name];
        }
    }
    
    NSAttributedString* descriptionString =
    [[NSAttributedString alloc] initWithString:[array componentsJoinedByString:@"\n"]
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0], NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    NSMutableAttributedString* attrString = [NSMutableAttributedString new];
    [attrString appendAttributedString:nameString];
    [attrString appendAttributedString:schoolString];
    [attrString appendAttributedString:descriptionString];
    
    self.textLabel.attributedText = attrString;
}


@end

