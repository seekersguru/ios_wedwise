//
//  AppDelegate.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "AppDelegate.h"
#import "MyKnotList.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "WWDashboardVC.h"
#import "WWLoginVC.h"
#import <GooglePlus/GooglePlus.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "WWMessageList.h"
#import "WWCreateBidVC.h"
#import "WWScheduleVC.h"
#import "WWLeadsListVC.h"
#import "WWSideMenuVC.h"
#import "WWProfileVC.h"
#import "WWRegistrationVC.h"

void uncaughtExceptionHandler(NSException*);

@interface AppDelegate ()

@end

@implementation AppDelegate

static AppDelegate * _sharedInstance;

+(instancetype)sharedAppDelegate{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (NSString* family in [UIFont familyNames])
    {
        //NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
          //  NSLog(@"  %@", name);
        }
    }
   // return YES;
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //Start network reachability monitoring:
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
#if !__has_feature(objc_arc)
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    
    NSString *savedIdentifier = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"identifier"];
    
    if(savedIdentifier.length>0){
        NSString *savedGroomName = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"groom_name"];
        
        _navigation=[[UINavigationController alloc]init];
        if(savedGroomName.length>0){
             UITabBarController *tabVC = [self setupViewControllers:nil];
             [_navigation pushViewController:tabVC animated:YES];
        }
        else{
            UITabBarController *tabVC = [self setupViewControllers:nil];
            [_navigation pushViewController:tabVC animated:YES];
        }
    }
    else{
        WWDashboardVC *dashboard=[[WWDashboardVC alloc]init];
        _navigation=[[UINavigationController alloc]initWithRootViewController:dashboard];
    }
    
    [self.window setRootViewController:_navigation];
    [self.window makeKeyAndVisible];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation 
{
    if([url.absoluteString rangeOfString:@"fb710911475711792"].location != NSNotFound){
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    else{
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}
- (UITabBarController *)setupViewControllers:(UITabBarController *)tabVC{
    if (!tabVC) {
        tabVC = [[UITabBarController alloc] init];
    }
    UIViewController *firstViewController = [[MyKnotList alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    NSString *savedGroomName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"identifier"];
    UINavigationController *secondNavigationController;
    if(savedGroomName.length>0){
        UIViewController *secondViewController = [[WWMessageList alloc] init];
        secondNavigationController= [[UINavigationController alloc]
                                     initWithRootViewController:secondViewController];
    }
    else{
        UIViewController *secondViewController = [[WWDashboardVC alloc] init];
        secondNavigationController = [[UINavigationController alloc]
                                      initWithRootViewController:secondViewController];
    }
    
    UINavigationController *thirdNavigationController;
    if(savedGroomName.length>0){
        UIViewController *thirdViewController = [[WWLeadsListVC alloc] init];
        thirdNavigationController = [[UINavigationController alloc]
                                     initWithRootViewController:thirdViewController];
    }
    else{
        UIViewController *thirdViewController = [[WWDashboardVC alloc] init];
        thirdNavigationController = [[UINavigationController alloc]
                                     initWithRootViewController:thirdViewController];
    }
    UIViewController *fourthViewController = [[WWSideMenuVC alloc] init];
    UINavigationController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    
    [tabVC setViewControllers:@[firstNavigationController,
                                secondNavigationController,
                                thirdNavigationController,
                                fourthNavigationController]];
    
    NSArray *tabBarItemImages = @[@"home", @"message", @"led", @"menu"];
    NSArray *tabBarSelectedItemImages = @[@"home_icon", @"message_icon", @"sbid",@"menu_icon"];
    
    [self customizeTabBarForController:tabVC images:tabBarItemImages selectedImages:tabBarSelectedItemImages];
    return tabVC;
}

-(void)resetViewControllerOnTabbar:(UITabBarController*)tabVC{
    if (!tabVC) {
        tabVC = [[UITabBarController alloc] init];
    }
    UIViewController *firstViewController = [[MyKnotList alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[WWMessageList alloc] init];
    UINavigationController *secondNavigationController= [[UINavigationController alloc]
                                                         initWithRootViewController:secondViewController];

    UIViewController *thirdViewController = [[WWLeadsListVC alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:thirdViewController];
    
    UIViewController *fourthViewController = [[WWSideMenuVC alloc] init];
    UINavigationController *fourthNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:fourthViewController];
    
    [tabVC setViewControllers:@[firstNavigationController,
                                secondNavigationController,
                                thirdNavigationController,
                                fourthNavigationController]];
    
    NSArray *tabBarItemImages = @[@"home", @"message", @"led",@"menu"];
    NSArray *tabBarSelectedItemImages = @[@"home_icon", @"message_icon", @"led",@"menu_icon"];
    
    [self customizeTabBarForController:tabVC images:tabBarItemImages selectedImages:tabBarSelectedItemImages];
    
}

- (void)customizeTabBarForController:(UITabBarController *)tabBarController images:(NSArray *)images selectedImages:(NSArray *)selectedImages{
    
    NSInteger index = 0;
    for (UITabBarItem *item in [[tabBarController tabBar] items]) {
        
        [item setImage:[UIImage imageNamed:[images objectAtIndex:index]]];
        item.selectedImage= [[UIImage imageNamed:[selectedImages objectAtIndex:index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        index++;
        
    }
}

- (void)changeTabBarVC:(UITabBarController *)tabVC{
    
    UIViewController *homeViewController = [[MyKnotList alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:homeViewController];
    
    UIViewController *firstViewController = [[WWCreateBidVC alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[WWCreateBidVC alloc] init];
    UINavigationController *secondNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[WWMessageList alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:thirdViewController];
    
    UIViewController *fourthViewController = [[WWScheduleVC alloc] init];
    UINavigationController *fourthNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:fourthViewController];
    [tabVC setViewControllers:@[homeNavigationController, firstNavigationController, secondNavigationController, thirdNavigationController,fourthNavigationController]];
    
    NSArray *tabBarItemImages = @[@"home", @"home", @"message", @"led", @"menu"];
    NSArray *tabBarSelectedItemImages = @[@"home_icon", @"home_icon", @"message_icon", @"led", @"menu_icon"];
    [self customizeTabBarForController:tabVC images:tabBarItemImages selectedImages:tabBarSelectedItemImages];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.WeddingWise" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeddingWise" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeddingWise.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}
