//
//  DetaiViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "DetaiViewController.h"
#import "MyoController.h"
@interface DetaiViewController ()

@end

@implementation DetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MyoController sharedManager]setCurrentView:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTap:(id)sender {
    [[MyoController sharedManager] setCurrentView:self.fromView];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)settingButtonLabel:(id)sender {
    
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
