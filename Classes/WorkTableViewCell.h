//
//  WorkTableViewCell.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"


@interface WorkTableViewCell : UITableViewCell
{
    Work* work;
    
    UILabel* nameLabel;
    UILabel* employerLabel;
    UILabel* descriptionLabel;
}

@property (nonatomic, strong) Work* work;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* employerLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;

@end
