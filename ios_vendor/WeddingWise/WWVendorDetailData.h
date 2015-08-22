//
//  WWVendorDetailData.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWVendorDetailData : NSObject
@property(nonatomic, strong)NSString *vendorEmail;
@property(nonatomic, strong)NSString *topName;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *top_address;
@property(nonatomic, strong)NSString *contact;
@property(nonatomic, strong)NSString *startingPrice;
@property(nonatomic, strong)NSArray *heroImages;
@property(nonatomic, strong)NSArray *videoLinks;
@property(nonatomic, strong)NSArray *panormaImages;
+ (instancetype)sharedInstance;
-(void)setVendorBasicInfo:(NSDictionary*)basicInfo;
@end

@interface WWVendorBidData : NSObject
@property(nonatomic, strong) NSMutableArray *time_slot;
@property(nonatomic, strong) NSDictionary *package;
@property(nonatomic, strong) NSDictionary *quoted;
@property(nonatomic, strong) NSNumber *maxItemPerPlate;
@property(nonatomic, strong) NSNumber *minItemPerPlate;
@property(nonatomic, strong) NSNumber *maxPerson;
@property(nonatomic, strong) NSNumber *minPerson;
@property(nonatomic, strong) NSDictionary *bidDictionary;

+ (instancetype)sharedInstance;
-(void)setVendorBidInfo:(NSDictionary*)bidInfo;
@end

@interface WWVendorBookingData : NSObject
@property(nonatomic, strong) NSMutableArray *time_slot;
@property(nonatomic, strong) NSDictionary *package;
@property(nonatomic, strong) NSDictionary *bookDictionary;
+ (instancetype)sharedInstance;
-(void)setVendorBookingInfo:(NSDictionary*)bookingInfo;
@end

@interface WWVendorDescription : NSObject
@property(nonatomic, strong)NSString* heading;
@property(nonatomic, strong)NSString* type;

@property(nonatomic, strong)NSArray *arrDescriptionData;
@property(nonatomic, strong)NSArray *arrPackageData;


@property(nonatomic, strong)NSArray *descReadMoreData;

-(WWVendorDescription*)setVendorDescrition:(NSDictionary*)descriptionInfo;

@end


@interface WWVendorFacility : NSObject
@property(nonatomic, strong)NSString* heading;
@property(nonatomic, strong)NSString* type;

@property(nonatomic, strong)NSArray *arrFacilityData;
@property(nonatomic, strong)NSArray *facilityReadMoreData;

-(WWVendorFacility*)setVendorFacility:(NSDictionary*)descriptionInfo;

@end

@interface WWVendorPackage : NSObject
@property(nonatomic, strong)NSString* heading;
@property(nonatomic, strong)NSString* type;

@property(nonatomic, strong)NSArray *arrPackageData;
@property(nonatomic, strong)NSArray *packageReadMoreData;

-(WWVendorPackage*)setVendorPackage:(NSDictionary*)packageInfo;

@end

@interface WWVendorMap : NSObject
@property(nonatomic, strong)NSString* heading;
@property(nonatomic, strong)NSString* type;
@property(nonatomic, strong) NSString* latitude;
@property(nonatomic, strong) NSString* longitude;
@property(nonatomic, strong)NSArray *arrPackageData;
@property(nonatomic, strong)NSArray *packageReadMoreData;

-(WWVendorMap*)setVendorMap:(NSDictionary*)mapInfo;
@end


