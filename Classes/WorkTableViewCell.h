//
//  WorkTableViewCell.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"


@interface WorkTableViewCell : UITableViewCell
{
    Work* work;
    
    UILabel* nameLabel;
    UILabel* employerLabel;
    UILabel* positionLabel;
    UILabel* dateLabel;
    UILabel* locationLabel;
}

@property (nonatomic, retain) Work* work;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UILabel* employerLabel;
@property (nonatomic, retain) UILabel* positionLabel;
@property (nonatomic, retain) UILabel* dateLabel;
@property (nonatomic, retain) UILabel* locationLabel;

@end
