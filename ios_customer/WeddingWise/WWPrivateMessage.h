//
//  WWPrivateMessage.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "JSQMessages.h"

@interface WWPrivateMessage : JSQMessagesViewController
@property(weak, nonatomic)IBOutlet UILabel *lblVendorName;
@property(nonatomic, strong)NSDictionary *messageData;
@end
