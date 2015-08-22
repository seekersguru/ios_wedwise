//
//  WWLoginUserData.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/13/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWLoginUserData : NSObject

@property(nonatomic, strong)NSString *identifier;
@property(nonatomic, strong)NSString *emailID;
@property(nonatomic, strong)NSString *brideName;
@property(nonatomic, strong)NSString *groomName;
@property(nonatomic, strong)NSString *contactNumber;
@property(nonatomic, strong)NSString *tentativeDate;
@property(nonatomic, strong)NSString *contactName;

@property(nonatomic, assign)BOOL isProfileComplete;

-(instancetype)setUserData:(NSDictionary*)userData;

@end
