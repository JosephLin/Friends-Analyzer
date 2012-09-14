//
//  WorkTableViewCell.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "WorkTableViewCell.h"
#import "User.h"

#define kLeftMargin         12.0
#define kRightMargin        30.0


@implementation WorkTableViewCell

@synthesize work;
@synthesize nameLabel, employerLabel, descriptionLabel;


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
        
        employerLabel = [[UILabel alloc] init];
        employerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        employerLabel.font = [UIFont boldSystemFontOfSize:16.0];
        employerLabel.numberOfLines = 0;
        employerLabel.textColor = [UIColor darkGrayColor];
        employerLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:employerLabel];
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat width = self.bounds.size.width - kLeftMargin - kRightMargin;
    CGFloat height = self.bounds.size.height;
    
    nameLabel.frame = CGRectMake(kLeftMargin, 0, width, height * 0.25);
    employerLabel.frame = CGRectMake(kLeftMargin, height * 0.20, width, height * 0.40);
    descriptionLabel.frame = CGRectMake(kLeftMargin, height * 0.55, width, height * 0.45);
}

- (void)setWork:(Work *)theWork
{
    work = theWork;
    
    self.nameLabel.text = work.user.name;
    self.employerLabel.text = work.employer.name;
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
    if (work.position.name) [array addObject:work.position.name];
    if ([work workDate]) [array addObject:[work workDate]];
    if ( work.location ) [array addObject:work.location];
    
    self.descriptionLabel.text = [array componentsJoinedByString:@" - "];
}


@end
