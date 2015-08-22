//
//  myKnotCell.h
//  DemoSlideMenu
//
//  Created by Dotsquares on 5/6/15.
//  Copyright (c) 2015 Dotsquares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myKnotCell : UITableViewCell
@property (nonatomic, strong)IBOutlet UIImageView *leftImage;
@property (nonatomic, strong)IBOutlet UIImageView *rightImage;

@property (nonatomic, strong)IBOutlet UIButton *leftButton;
@property (nonatomic, strong)IBOutlet UIButton *rightButton;
@end
