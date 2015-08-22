//
//  WWWebService.m
//  WeddingWise
//
//  Created by Dotsquares on 7/2/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWWebService.h"

static WWWebService * _sharedInstance;
@implementation WWWebService


#pragma mark Web Api shared instance method
+(instancetype)sharedInstanceAPI{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark check reachability method:
-(BOOL)checkReachablity//:(void (^)(BOOL))reachableBlock{
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

-(void)checkReachablity:(void (^)(BOOL))reachableBlock{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __block BOOL reachable;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"No Internet Connection");
                reachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                DLog(@"Reachable via wifi");
                reachable = YES;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"Reachable via WAN");
                reachable = YES;
                break;
            default:
                DLog(@"Unkown network status");
                reachable = NO;
                break;
        }
        reachableBlock(reachable);
    }];
}

#pragma mark web api method:
-(void)callWebService:(NSDictionary *)parameters imgData:(NSData *)imageData loadThreadWithCompletion:(void(^)(NSDictionary * response))cmpl failure:(void(^)(NSString *failureResponse))failure
{
    if([self checkReachablity]){
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [MBProgressHUD showHUDAddedTo:appdelegate.window animated:YES];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kWebServiceUrl]];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:[NSString stringWithFormat:@"%@/",[parameters valueForKey:@"action"]] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:appdelegate.window animated:YES];
            DLog(@"%@ :%@",[parameters valueForKey:@"action"], responseObject);
            cmpl(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:appdelegate.window animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving loginUser"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
    }
    else{
        DLog(@"Non Reachable");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"No network connection"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
