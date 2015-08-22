//
//  WWWebService.h
//  WeddingWise
//
//  Created by Dotsquares on 7/2/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWebService : NSObject

+(instancetype)sharedInstanceAPI;

-(void)callWebService:(NSDictionary *)parameters imgData:(NSData *)imageData loadThreadWithCompletion:(void(^)(NSDictionary * response))cmpl failure:(void(^)(NSString *failureResponse))failure;
@end
