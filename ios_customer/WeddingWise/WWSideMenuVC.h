//
//  WWSideMenuVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWSideMenuVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblMenuList;
}
@end
