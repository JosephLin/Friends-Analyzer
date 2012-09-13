//
//  FriendsAnalyzerAppDelegate.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UIColor+Utilities.h"
#import "FlurryAnalytics.h"
#import "FacebookSDK.h"



@interface AppDelegate ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end



@implementation AppDelegate


#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:@"2A8KB89EMT16MTUQR3JI"];
    [FlurryAnalytics logAllPageViews:self.navigationController];

    [self customizeAppearance];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    // this means the user switched back to this app without completing
//    // a login in Safari/Facebook App
//    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
//        [FBSession.activeSession close]; // so we close our session and start over
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
    [FBSession.activeSession close];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{    
    if (!_managedObjectContext)
    {
        if (self.persistentStoreCoordinator)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        }
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"FriendsAnalyzer" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{    
    if (!_persistentStoreCoordinator)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

        NSError *error = nil;
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    if (self.managedObjectContext)
    {
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSURL*)storeURL
{
	NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FriendsAnalyzer.sqlite"];
	return storeURL;
}

- (void)deleteCoreDataStorage
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUserID"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastUpdated"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
	self.managedObjectContext = nil;
	self.managedObjectModel = nil;
	self.persistentStoreCoordinator = nil;
	
	NSError* error = nil;
	[[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:&error];
	if ( error )
	{
		NSLog(@"Error Deleting Storage: %@", error);
	}
	else
	{
		NSLog(@"Core Data Storage Deleted.");
	}
}


#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}


#pragma mark - Customize Appearance

- (void)customizeAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor finfoBlueColor]];
    [[UIToolbar appearance] setTintColor:[UIColor finfoBlueColor]];    
    [[UIProgressView appearance] setProgressTintColor:[UIColor lightBlueColor]];
}


#pragma mark - Flurry

void uncaughtExceptionHandler(NSException *exception)
{
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}



@end



