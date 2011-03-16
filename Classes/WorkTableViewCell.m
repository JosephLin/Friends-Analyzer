//
//  WorkTableViewCell.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkTableViewCell.h"
#import "User.h"

#define kLeftMargin         12.0
#define kRightMargin        30.0


@implementation WorkTableViewCell

@synthesize work;
@synthesize nameLabel, employerLabel, positionLabel, dateLabel, locationLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = self.bounds.size.width - kLeftMargin - kRightMargin;
        CGFloat height = self.bounds.size.height;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, 0, width, height * 0.30)];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumFontSize = 10.0;
        [self addSubview:nameLabel];
        
        employerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, height * 0.30, width, height * 0.20)];
        employerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        employerLabel.font = [UIFont boldSystemFontOfSize:20.0];
        employerLabel.adjustsFontSizeToFitWidth = YES;
        employerLabel.minimumFontSize = 10.0;
        [self addSubview:employerLabel];
        
        positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, height * 0.50, width, height * 0.15)];
        positionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        positionLabel.font = [UIFont boldSystemFontOfSize:14.0];
        positionLabel.adjustsFontSizeToFitWidth = YES;
        positionLabel.minimumFontSize = 10.0;
        [self addSubview:positionLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, height * 0.65, width, height * 0.15)];
        dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dateLabel.font = [UIFont boldSystemFontOfSize:10.0];
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.minimumFontSize = 10.0;
        [self addSubview:dateLabel];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, height * 0.80, width, height * 0.15)];
        locationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        locationLabel.font = [UIFont boldSystemFontOfSize:10.0];
        locationLabel.adjustsFontSizeToFitWidth = YES;
        locationLabel.minimumFontSize = 10.0;
        [self addSubview:locationLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWork:(Work *)theWork
{
    [work autorelease];
    work = [theWork retain];
    
    self.nameLabel.text = work.user.name;
    self.employerLabel.text = work.employer.name;
    self.positionLabel.text = work.position.name;
//    self.dateLabel.text = [NSString stringWithFormat:@"%@/%@ to %@/%@", work.
    self.locationLabel.text = work.location;
}

- (void)dealloc
{
    [work release];
    [nameLabel release];
    [employerLabel release];
    [positionLabel release];
    [dateLabel release];
    [locationLabel release];
    [super dealloc];
}

@end
