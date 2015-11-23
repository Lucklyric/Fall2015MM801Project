//
//  CalibrateViewController.h
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-23.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalibrateViewController : UIViewController
@property (weak,nonatomic)  UIViewController *fromView;
@property (weak, nonatomic) IBOutlet UILabel *myoStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property (weak, nonatomic) IBOutlet UIImageView *cal1Image;
@property (weak, nonatomic) IBOutlet UIImageView *cal2Image;
@property (assign,nonatomic) NSInteger calStatus;
@end
