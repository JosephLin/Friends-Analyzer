//
//  GeocodeTableViewCell.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GeocodeTableViewCell : UITableViewCell
{
    UILabel* titleLabel;
    UILabel* countLabel;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* countLabel;

@end