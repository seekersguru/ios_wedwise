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
                         
                     }
                     
                 }];
            }
        }
        else{
            NSLog(@"Error :%@", error);
        }
    }];
}
#pragma mark - Facebook Login
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
                         //FBSDKAccessToken *tokenStr=result.token;
                         [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"getDataformFb" object:user]];
                     }
                 }];
            }
        }
    }];
}

#pragma mark - Post Detail to Facebook
-(void)postDetailToFacebook{
    if (![FBSDKAccessToken currentAccessToken]) {
        [[[UIAlertView alloc] initWithTitle:@"Login!" message:@"Please facebook login first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    //    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //    [login logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    //        if (!error) {
    [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"me/feed"
      parameters: @{ @"message" : @"hello world"}
      HTTPMethod:@"POST"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"Post id:%@", result[@"id"]);
         }
     }];
    //        }
    //    }];
}

#pragma mark - Send Image To Messenger
-(void)sendImageToMessenger{
    if (![FBSDKAccessToken currentAccessToken]) {
        [[[UIAlertView alloc] initWithTitle:@"Login!" message:@"Please facebook login first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityImage) {
        // Messanger Installed
        UIImage *image = [UIImage imageNamed:@"icon_target"];
        [FBSDKMessengerSharer shareImage:image withOptions:nil];
    }
    else{
        NSString *appStoreLink = @"https://itunes.apple.com/en/app/facebook-messenger/id454638411?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
    }
}

-(void)facebookLogout{
    if (login==nil) {
        login = [[FBSDKLoginManager alloc] init];
    }
    [login logOut];
}

-(void)inviteAppToFacebookFriend{
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
        content.appLinkURL = [NSURL URLWithString:@"http://wds1.projectstatus.co.uk/Airdates/applinks.html"];
        content.previewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
        // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
        [FBSDKAppInviteDialog showWithContent:content
                                     delegate:self];
    }
    else
    {
        NSArray *readPermissions = @[@"public_profile",@"email",@"user_friends",@"user_about_me",@"user_birthday",@"read_custom_friendlists"];
        login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:readPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                if ([FBSDKAccessToken currentAccessToken]) {
                    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
                    content.appLinkURL = [NSURL URLWithString:@"http://wds1.projectstatus.co.uk/Airdates/applinks.html"];
                    content.previewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
                    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
                    [FBSDKAppInviteDialog showWithContent:content
                                                 delegate:self];
                }
            }
        }];
        
    }
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"%@",results);
    
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    NSLog(@"%@",[error description]);
}

@end
