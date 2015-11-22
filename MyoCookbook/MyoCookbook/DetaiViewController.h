//
//  DetaiViewController.h
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetaiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myoStatusLabel;
@property (weak, nonatomic) IBOutlet UITextView *scrollTextField;
@property (weak,nonatomic)  UIViewController *fromView;
@property (assign,nonatomic) float preOffset;
@property (assign,nonatomic) NSInteger fistStatus;
@property (assign,nonatomic) NSInteger trackingLine; //1,back 2,text
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
