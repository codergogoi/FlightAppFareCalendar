//
//  AppDelegate.h
//  FlightAppCalender
//
//  Created by MAC01 on 04/10/17.
//  Copyright © 2017 Jayanta Gogoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

