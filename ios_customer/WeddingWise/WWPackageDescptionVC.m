//
//  WWPackageDescptionVC.m
//  WedWise
//
//  Created by Deepak Sharma on 8/22/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWPackageDescptionVC.h"

@interface WWPackageDescptionVC ()

@end

@implementation WWPackageDescptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_strPackageDesc]];
    [_wbView loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
