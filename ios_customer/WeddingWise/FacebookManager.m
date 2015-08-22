//
//  FacebookManager.m
//  FacebookLogin
//
//  Created by admin on 5/12/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager

+(instancetype)sharedManager{
    static FacebookManager *sharedManager=nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedManager=[[self alloc] init];
    });
    return sharedManager;
}

-(id)init{
    if (self=[super init]) {
        
    }
    return self;
}

#pragma mark - Facebook Login
-(void)callFaceBookLogin:(void(^)(NSDictionary * response))cmpl failure:(void(^)(NSString *failureResponse))failure{
    
    NSArray *readPermissions = @[@"public_profile",@"email"];
    login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:readPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (!error) {
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSMutableDictionary* user, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", user);
                         FBSDKAccessToken *tokenStr=result.token;
                         
                         cmpl(user);
                         //[[DELEGATE userseccionObj] setObjectFB:user :tokenStr.tokenString];
//                         [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"getDataformFb" object:tokenStr.tokenString]];
                     }
                     
                 }];
            }
        }
        else{
            NSLog(@"Error :%@", error);
        }
    }];
}

-(void)facebookLogin{
    
    NSArray *readPermissions = @[@"public_profile",@"email"];
    login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:readPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (!error) {
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSMutableDictionary* user, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", user);
                         FBSDKAccessToken *tokenStr=result.token;
                         [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"getDataformFb" object:user]];
                     }
                 }];
            }
        }
    }];
}
@end
