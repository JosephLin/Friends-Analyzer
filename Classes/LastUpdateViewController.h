//
//  LastUpdateViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LastUpdateViewController : UITableViewController
{
    NSFetchedResultsController* fetchedResultsController;
    NSArray* sectionIndexTitles;
}

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSArray* sectionIndexTitles;

@end
