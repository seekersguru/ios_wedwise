//
//  WWSideMenuVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWSideMenuVC.h"
#import "WWProfileVC.h"
#import "WWDashboardVC.h"
#import "WWChangePasswordVC.h"
#import "WWAvailabilityVC.h"
#import "WWCreateBidVC.h"

@interface WWSideMenuVC ()
{
    NSArray *menuData;
}
@end

@implementation WWSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    menuData =[[NSArray alloc]initWithObjects:@"Update Availability",@"Logout", nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [menuData objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:AppFont size:17.0]];
    return cell;
}
- (IBAction)backCliked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            WWAvailabilityVC *availabilityVC = [[WWAvailabilityVC alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:availabilityVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 1:{
            WWDashboardVC *dash=[[WWDashboardVC alloc]initWithNibName:@"WWDashboardVC" bundle:nil];
            dash.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dash animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
