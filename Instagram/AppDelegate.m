//
//  AppDelegate.m
//  Instagram
//
//  Created by ilanashapiro on 7/8/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     // Code to initialize Parse
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"fbuInstagramIShapiro";
        configuration.server = @"https://fbu-instagram-ishapiro.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (PFUser.currentUser) {
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        UITabBarController *tabBarController = [[UITabBarController alloc] initWithNibName:@"HomeScreenViewController" bundle:nil];
        tabBarController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"All Posts" image:nil tag:nil];
        [tabBarController setViewControllers:@[navigationController] animated:YES];
        self.window.rootViewController = tabBarController;
        //[self.window makeKeyAndVisible];
    }
    else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"StartScreenViewController"];
    }
    
    /* code to test server is working
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    gameScore[@"score"] = @1400;
    gameScore[@"playerName"] = @"Jane Doe";
    gameScore[@"cheatMode"] = @NO;
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];*/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
