//
//  FacebookManager.h
//  FacebookLogin
//
//  Created by admin on 5/12/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface FacebookManager : NSObject<FBSDKAppInviteDialogDelegate>
{
    FBSDKLoginManager *login;
}
-(void)callFaceBookLogin:(void(^)(NSDictionary * response))cmpl failure:(void(^)(NSString *failureResponse))failure;


+(instancetype)sharedManager;
-(void)postDetailToFacebook;
-(void)facebookLogin;
-(void)facebookLogout;
-(void)sendImageToMessenger;
-(void)inviteAppToFacebookFriend;
@end
