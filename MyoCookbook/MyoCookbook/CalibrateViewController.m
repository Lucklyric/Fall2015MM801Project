//
//  CalibrateViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-23.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "CalibrateViewController.h"
#import "MyoController.h"

@interface CalibrateViewController ()

@end

@implementation CalibrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calStatus = 1;
    
    NSLog(@"connection:%d,syscnStatus:%d,unlock%d",[[MyoController sharedManager]connectionStatus],[[MyoController sharedManager]syncStatus],[[MyoController sharedManager]unlockStatus]);
    
    // Do any additional setup after loading the view.
    if ([[MyoController sharedManager]connectionStatus] ==1 ) {
        if ([[MyoController sharedManager]syncStatus]==1) {
            if ([[MyoController sharedManager]unlockStatus]==1) {
                self.myoStatusLabel.backgroundColor = [UIColor greenColor];
                self.myoStatusLabel.text = @"UnLock";
            }else{
                self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
                self.myoStatusLabel.text = @"Locked";
            }
        }else{
            self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
            self.myoStatusLabel.text = @"UnSyn";
            
        }
    }else{
        self.myoStatusLabel.backgroundColor = [UIColor redColor];
        self.myoStatusLabel.text = @"UnCon";
    }
    [[MyoController sharedManager]setCurrentView:self];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myoCoookBookGestureCallback:)
                                                 name:@"MyoCookbookGesture"
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [[MyoController sharedManager] setCurrentView:self.fromView];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)fistCallback{
    if (self.calStatus == 1) {
        [[MyoController sharedManager]calibrateUD];
        [self.cal1Image setHidden:YES];
        [self.cal2Image setHidden:NO];
        self.textLable.backgroundColor = [UIColor orangeColor];
        self.textLable.text = @"2. Please hold your arm as shown in the picture below and make the FIST";
        self.calStatus = 2;
    }else if (self.calStatus == 2){
        [[MyoController sharedManager]calibrateLR];
        self.textLable.text = @"Calibration Finished";
        self.textLable.backgroundColor = [UIColor greenColor];

    }
}

- (void)myoCoookBookGestureCallback:(NSNotification *)notification {
    NSLog(@"Myo Gesture Callback hit");
    NSString* notif = @"";
    NSString* gestureName = [notification object];
    if ([gestureName isEqual:@"MyoConnect"]) {
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"UnSyn";
        notif = @"Myo Connected";
        NSLog(@"Myo Connected");
    }else if([gestureName isEqual:@"MyoUnconnect"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"UnCon";
        notif = @"Myo UnConnect";
        NSLog(@"Myo UnConnect");
    }else if([gestureName isEqual:@"MyoSync"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"Locked";
        notif = @"Myo MyoSync";
        NSLog(@"Myo Syned");
    }else if([gestureName isEqual:@"MyoUnsync"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"UnSyn";
        NSLog(@"Myo UnSyned");
        notif = @"Myo MyoUnsync";
        
    }else if([gestureName isEqual:@"MyoUnlock"]){
        self.myoStatusLabel.backgroundColor = [UIColor greenColor];
        self.myoStatusLabel.text = @"UnLock";
        NSLog(@"Myo UnLock");
        notif = @"Myo UnLcoked";
    }else if([gestureName isEqual:@"MyoLock"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"Locked";
        NSLog(@"Myo Locked");
        notif = @"Myo Locked";
        
    }else if([gestureName isEqual:@"MyoGestureFist"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;

        [self fistCallback];
        NSLog(@"Myo fist");
        notif = @"Fist Gesture";
        
    }
}
@end
