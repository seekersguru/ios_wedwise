//
//  ViewController.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyKnotList : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak)IBOutlet UITableView *tblMyKnotList;

-(IBAction)messageButtonPressed:(id)sender;

-(IBAction)backButtonPressed:(id)sender;
@end

