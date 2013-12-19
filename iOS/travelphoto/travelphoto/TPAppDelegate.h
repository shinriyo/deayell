//
//  TPAppDelegate.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/25.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController;
@class TPLoginController;

@interface TPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) JASidePanelController *viewController;


@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) TPLoginController *tpLoginController;
@property (strong, nonatomic) UINavigationController *tpLoginNav;




- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
