//
//  WWScheduleListingVC.m
//  WedWise
//
//  Created by Deepak Sharma on 8/17/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWScheduleListingVC.h"

@interface WWScheduleListingVC ()
{
    NSMutableArray *arrScheduleData;
    NSString *lastVendorEmail;
}
@end

@implementation WWScheduleListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
     _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    arrScheduleData =[[NSMutableArray alloc]init];
    lastVendorEmail = @"";
    [self callWebService];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callWebService{
    
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"schedule_list",@"action",
                                 lastVendorEmail,@"vendor_email",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"responseDics :%@", responseDics);
         for (NSDictionary *dic in responseDics[@"json"][@"list"]) {
             [arrScheduleData addObject:dic];
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [_tblView reloadData];
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrScheduleData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *moreCellId = @"moreCell";
    UITableViewCell *cell = nil;
    
    NSUInteger row = [indexPath row];
    NSUInteger count = [arrScheduleData count];
    
    if (row == count) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:moreCellId];
        }
        
        [self callWebService];
        
        cell.textLabel.text = @"Load more items...";
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        
    }
    else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [arrScheduleData objectAtIndex:indexPath.row][@"vendor"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ssZZZ"];
        
        NSDate *date = [dateFormatter dateFromString:[arrScheduleData objectAtIndex:indexPath.row][@"time"]];
        
        cell.detailTextLabel.text = [arrScheduleData objectAtIndex:indexPath.row][@"time"];
        
        [cell.textLabel setTextColor:[UIColor colorWithRed:243.0f/255.0f green:150.0f/255.0f blue:141.0f/255.0f alpha:1.0]];
        
        [cell.textLabel setFont:[UIFont fontWithName:AppFont size:15.0]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:AppFont size:13.0]];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
//    if ((indexPath.row == [arrScheduleData count] - 1))
//    {
//        lastVendorEmail = [arrScheduleData[indexPath.row] valueForKey:@"vendor_email"];
//        [self callWebService];
//    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
