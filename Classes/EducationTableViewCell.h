//
//  EducationTableViewCell.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Education.h"


@interface EducationTableViewCell : UITableViewCell
{
    Education* education;
    
    UILabel* nameLabel;
    UILabel* schoolLabel;
    UILabel* descriptionLabel;
}

@property (nonatomic, strong) Education* education;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* schoolLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;

@end
