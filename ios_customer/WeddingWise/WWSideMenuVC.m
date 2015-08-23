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
#import "WWFavoriteVendorsVC.h"
#import "WWScheduleListingVC.h"

@interface WWSideMenuVC ()
{
    NSArray *menuData;
}
@end

@implementation WWSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblMenuList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    menuData =[[NSArray alloc]initWithObjects:@"Favorite",@"Profile",@"Schedule list",@"Logout", nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            WWFavoriteVendorsVC *profileVC=[[WWFavoriteVendorsVC alloc]initWithNibName:@"WWFavoriteVendorsVC" bundle:nil];
            [self.navigationController pushViewController:profileVC animated:YES];
        }
            break;
        case 1:
        {
            WWProfileVC *profileVC=[[WWProfileVC alloc]initWithNibName:@"WWProfileVC" bundle:nil];
            [self.navigationController pushViewController:profileVC animated:YES];
        }
            break;
        case 2:
        {
            WWScheduleListingVC *scheduleVisit=[[WWScheduleListingVC alloc]initWithNibName:@"WWScheduleListingVC" bundle:nil];
            [self.navigationController pushViewController:scheduleVisit animated:YES];
        }
            break;
        case 3:{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"identifier"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"groom_name"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EmailID"];
            
            
            [AppDelegate sharedAppDelegate].isLogOut= YES;
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
