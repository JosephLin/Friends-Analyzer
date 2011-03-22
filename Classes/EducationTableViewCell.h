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

@property (nonatomic, retain) Education* education;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UILabel* schoolLabel;
@property (nonatomic, retain) UILabel* descriptionLabel;

@end
