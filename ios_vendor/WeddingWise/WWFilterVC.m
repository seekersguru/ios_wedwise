//
//  WWFilterVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWFilterVC.h"

@interface WWFilterVC ()

@end

@implementation WWFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)hideViewPressed:(id)sender {
    [self.delegate hideView];
    
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
