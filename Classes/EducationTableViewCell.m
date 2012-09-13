//
//  EducationTableViewCell.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EducationTableViewCell.h"
#import "User.h"

#define kLeftMargin         12.0
#define kRightMargin        30.0


@implementation EducationTableViewCell

@synthesize education;
@synthesize nameLabel, schoolLabel, descriptionLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        nameLabel = [[UILabel alloc] init];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumFontSize = 10.0;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        
        schoolLabel = [[UILabel alloc] init];
        schoolLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        schoolLabel.font = [UIFont boldSystemFontOfSize:16.0];
        schoolLabel.numberOfLines = 0;
        schoolLabel.textColor = [UIColor darkGrayColor];
        schoolLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:schoolLabel];
        
        descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        descriptionLabel.font = [UIFont systemFontOfSize:14.0];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.textColor = [UIColor darkGrayColor];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:descriptionLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat width = self.bounds.size.width - kLeftMargin - kRightMargin;
    CGFloat height = self.bounds.size.height;
    
    nameLabel.frame = CGRectMake(kLeftMargin, 0, width, height * 0.25);
    schoolLabel.frame = CGRectMake(kLeftMargin, height * 0.20, width, height * 0.40);
    descriptionLabel.frame = CGRectMake(kLeftMargin, height * 0.55, width, height * 0.45);
}

- (void)setEducation:(Education *)theEducation
{
    education = theEducation;
    
    self.nameLabel.text = education.user.name;
    self.schoolLabel.text = education.school.name;
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
    if ( education.year ) [array addObject:education.year];
    if ( education.degree ) [array addObject:education .degree.name];
    if ( education.concentrations )
    {
        for ( ObjectAttribute* object in education.concentrations )
        {
            [array addObject:object.name];
        }
    }
    self.descriptionLabel.text = [array componentsJoinedByString:@" - "];
}


@end

