//
//  GeocodeTableViewCell.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeocodeTableViewCell.h"

#define kLeftMargin         12.0
#define kCountLabelWidth    40.0
#define kRightMargin        30.0


@implementation GeocodeTableViewCell

@synthesize titleLabel, countLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, 0, width - kLeftMargin - kCountLabelWidth - kRightMargin, height)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 10.0;
//        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - kCountLabelWidth - kRightMargin, 0, kCountLabelWidth, height)];
        countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        countLabel.textAlignment = UITextAlignmentRight;
        countLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
        [self addSubview:countLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [titleLabel release];
    [countLabel release];
    [super dealloc];
}

@end
