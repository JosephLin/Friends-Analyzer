//
//  LastUpdateViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LastUpdateViewController : UITableViewController
{
    NSFetchedResultsController* fetchedResultController;
    NSArray* sectionIndexTitles;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) NSArray* sectionIndexTitles;

@end
