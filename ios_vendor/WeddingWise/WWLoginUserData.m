//
//  WWLoginUserData.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/13/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLoginUserData.h"

@implementation WWLoginUserData
-(instancetype)setUserData:(NSDictionary*)userData{
    
    [self setIdentifier:[userData valueForKey:@"identifier"]];
    return self;
}
@end
