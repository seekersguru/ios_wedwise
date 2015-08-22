//
//  WWFilterVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterProtocolDelegate <NSObject>

@required
- (void)hideView;
@end

@interface WWFilterVC : UIViewController
{
    // Delegate to respond back
    id <FilterProtocolDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;

@end
