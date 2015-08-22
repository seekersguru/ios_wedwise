//
//  WWBookingDetails.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWBookingDetails.h"
#import "WWBookingHeaderCell.h"
#import "WWBookingMiddleCell.h"
#import "WWBookingFooterCell.h"

@interface WWBookingDetails ()

@end

@implementation WWBookingDetails

- (void)viewDidLoad {
    
    [_tblBooking registerNib:[UINib nibWithNibName:@"WWBookingHeaderCell" bundle:nil] forCellReuseIdentifier:@"WWBookingHeaderCell"];
    [_tblBooking registerNib:[UINib nibWithNibName:@"WWBookingMiddleCell" bundle:nil] forCellReuseIdentifier:@"WWBookingMiddleCell"];
    [_tblBooking registerNib:[UINib nibWithNibName:@"WWBookingFooterCell" bundle:nil] forCellReuseIdentifier:@"WWBookingFooterCell"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==_tblBooking)
    {
        switch (indexPath.section) {
            case 0:
            {
                WWBookingHeaderCell *headerCell=[tableView dequeueReusableCellWithIdentifier:@"WWBookingHeaderCell"];
                headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                headerCell.lblTitle.text=@"Ramesh Weds Sujata";
                headerCell.lblAddress.text= @"Sanika Junction, Andheri Kurla road Andheri East, Mumbai 400073";
                headerCell.lblNumber.text= @"8739994888";
                
                return headerCell;
            }
                case 1:
            {
                WWBookingMiddleCell *middleCell=[tableView dequeueReusableCellWithIdentifier:@"WWBookingMiddleCell"];
                middleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                switch (indexPath.row) {
                    case 0:
                    {
                        middleCell.lblTitile.text=@"Event Date";
                        middleCell.lblName.text=@"Shared room";
                    }
                        break;
                    case 1:
                    {
                        middleCell.lblTitile.text=@"Time Slot";
                        middleCell.lblName.text=@"Monday Night";
                    }
                        break;
                    case 2:
                    {
                        middleCell.lblTitile.text=@"Package";
                        middleCell.lblName.text=@"500 RS Per plate Min. 100 Person";
                    }
                        break;
                    case 3:
                    {
                        middleCell.lblTitile.text=@"Bid Price";
                        middleCell.lblName.text=@"400 Person Min 100 Person";
                    }
                        break;
                        
                    default:
                        break;
                }
                return middleCell;
            }
                break;
            case 2:
            {
                WWBookingFooterCell *footerCell=[tableView dequeueReusableCellWithIdentifier:@"WWBookingFooterCell"];
                footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                
                
                return footerCell;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 147;
        }
        case 1:
        {
            return 50;
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
            
        default:
            break;
    }
    return 0.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
