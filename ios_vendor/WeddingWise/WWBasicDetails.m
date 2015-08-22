//
//  WWBasicDetails.m
//  WeddingWise
//
//  Created by Shivam on 7/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWBasicDetails.h"

@implementation WWBasicDetails
+ (instancetype)sharedInstance
{
    static WWBasicDetails *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WWBasicDetails alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
@end
