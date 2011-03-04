//
//  BirthdayViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorizedTableViewController.h"


@interface BirthdayViewController : UIViewController
{
    UITableView* tableView;
    NSFetchedResultsController* fetchedResultController;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@end
